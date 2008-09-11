Return-Path: <linux-kernel-owner+w=401wt.eu-S1755375AbYIKPUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375AbYIKPUv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 11:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbYIKPUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 11:20:42 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:51488 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbYIKPUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 11:20:41 -0400
Date: Thu, 11 Sep 2008 10:20:33 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: ebiederm@xmission.com, akpm@linux-foundation.org, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: unprivileged mounts git tree
Message-ID: <20080911152033.GA29318@us.ibm.com>
References: <E1Kb0ml-0006qL-5M@pomaz-ex.szeredi.hu> <20080903224334.GA726@us.ibm.com> <E1Kb8Y0-0008Gh-FP@pomaz-ex.szeredi.hu> <20080904132804.GA14709@us.ibm.com> <E1KbFU3-0002Ne-Oe@pomaz-ex.szeredi.hu> <E1KbGwb-0002rl-49@pomaz-ex.szeredi.hu> <20080905153134.GA18367@us.ibm.com> <E1Kd3Mh-0001vk-F5@pomaz-ex.szeredi.hu> <m11vzrge86.fsf@frodo.ebiederm.org> <E1KdnOb-00068L-Eq@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KdnOb-00068L-Eq@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Miklos Szeredi (miklos@szeredi.hu):
> On Thu, 11 Sep 2008, ebiederm@xmission.com (Eric W. Biederman)
> > There is a weird corner case I'm trying to wrap my head around.
> > unlink and rmdir do not work on dentries that are mount points
> > in another mount namespace.
> > 
> > Which is at least needed for the moment so we don't leak mounts.
> > 
> > Once we have unprivileged mounts does that introduce a DOS attack?
> 
> Hmm, yes.  That's a tough one...
> 
> I think if the dentry has only user mounts, unlink should go ahead and
> on success dissolve any mounts on the dentry.  Does that sound
> workable?
> 
> Thanks,
> Miklos

Is it really a problem?  The admin can always go ahead and kill the
user, which already takes care of any mounts in private namespaces,
which I think is Eric's primary concern.  IT also takes care of that
user's processes pinning files under the mounts.  So now the admin can
umount all the user's mounts in the init namespace (using a script
parsing /proc/self/mountinfo if need be), and delete the files.

Doesn't really seem like a problem.

Or am I missing Eric's real concern?

-serge
