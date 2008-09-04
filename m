Return-Path: <linux-kernel-owner+w=401wt.eu-S1755835AbYIDQRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbYIDQRv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 12:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754161AbYIDQRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 12:17:31 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:59050 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946AbYIDQRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 12:17:30 -0400
Date: Thu, 4 Sep 2008 11:17:29 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: ebiederm@xmission.com, akpm@linux-foundation.org, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: unprivileged mounts git tree
Message-ID: <20080904161729.GA26579@us.ibm.com>
References: <E1KYNMl-0000TG-Qs@pomaz-ex.szeredi.hu> <20080827184600.GA8069@us.ibm.com> <E1KaxLm-0006OD-K8@pomaz-ex.szeredi.hu> <20080903220215.GA27705@us.ibm.com> <E1Kb0ml-0006qL-5M@pomaz-ex.szeredi.hu> <20080903224334.GA726@us.ibm.com> <E1Kb8Y0-0008Gh-FP@pomaz-ex.szeredi.hu> <20080904132804.GA14709@us.ibm.com> <E1KbFU3-0002Ne-Oe@pomaz-ex.szeredi.hu> <E1KbGwb-0002rl-49@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KbGwb-0002rl-49@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Miklos Szeredi (miklos@szeredi.hu):
> On Thu, 04 Sep 2008, Miklos Szeredi wrote:
> > On Thu, 4 Sep 2008, Serge E. Hallyn wrote:
> > > Are you going to revert the change forcing CL_SLAVE for
> > > !capable(CAP_SYS_ADMIN)?  I don't think we want that - I think that
> > > *within* a set of user mounts, propagation should be safe, right?
> > > 
> > > Will you be able to do this soon?  If not, should we just do the part
> > > returning -EPERM when turning a shared mount into a user mount? 
> > 
> > OK, let's do that first and the tricky part (propagation vs. user
> > mounts) later.  Will push after I've tested it.
> 
> Here it is:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git unprivileged-mounts

but you're still doing

	if (IS_MNT_SHARED(old_nd.path.mnt) && !capable(CAP_SYS_ADMIN))
		goto out;

shouldn't it be something like

	if (IS_MNT_SHARED(old_nd.path.mnt) && (old_nd.path.mnt & MNT_USER))
		goto out;

?

> I don't know what's next, this patchset has been in and out of -mm for
> as long as I can remember, but it hasn't generated much interest
> outside the two of us :)
> 
> I do think this is an important feature though, even if not as sexy as
> some other things.
> 
> Al?  Is there any chance of this making it to 2.6.28?
> 
> Thanks,
> Miklos
