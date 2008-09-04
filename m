Return-Path: <linux-kernel-owner+w=401wt.eu-S1756557AbYIDXdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbYIDXdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 19:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753814AbYIDXcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 19:32:43 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:46911 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbYIDXcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 19:32:41 -0400
Date: Thu, 4 Sep 2008 18:32:40 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: ebiederm@xmission.com, akpm@linux-foundation.org, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: unprivileged mounts git tree
Message-ID: <20080904233240.GB9995@us.ibm.com>
References: <E1Kb8Y0-0008Gh-FP@pomaz-ex.szeredi.hu> <20080904132804.GA14709@us.ibm.com> <E1KbFU3-0002Ne-Oe@pomaz-ex.szeredi.hu> <E1KbGwb-0002rl-49@pomaz-ex.szeredi.hu> <20080904161729.GA26579@us.ibm.com> <E1KbIqL-0003QO-34@pomaz-ex.szeredi.hu> <20080904174851.GA13693@hallyn.com> <E1KbJBO-0003Xz-0G@pomaz-ex.szeredi.hu> <20080904184916.GA19328@us.ibm.com> <E1KbNHX-0004mH-Fw@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KbNHX-0004mH-Fw@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Miklos Szeredi (miklos@szeredi.hu):
> On Thu, 4 Sep 2008, Serge E. Hallyn wrote:
> > We still have the original problem.
> > 
> > When root does
> > 
> > 	mount -bind /mnt /mnt
> > 	mount --make-rshared /mnt
> > 	mount --bind -o user=hallyn /mnt /home/hallyn/mnt
> > 
> > and hallyn does
> > 
> > 	mount --bind /usr /home/hallyn/mnt/usr
> > 
> > then the kernel happily propagates the mount to /mnt/usr.
> 
> Obviously, and that's exactly what root _instructed_ in the last step.
> If it's a security problem, root shouldn't do that.
> 
> Your original bug report correctly pointed out the real security
> problem:
> 
> |  as root:
> |  	mmount --bind -o user=500 /home/hallyn/etc/ /home/hallyn/etc/
> |  	mount --bind /mnt /mnt
> |  	mount --make-rshared /mnt
> |  	mount --bind /dev /mnt/dev
> | 
> |  as hallyn:
> |  	mmount --bind /mnt /home/hallyn/etc/mnt
> |  	/usr/src/mmount-0.3/mmount --bind mnt/dev mnt/src
> 
> Here root does nothing "unsafe", yet the user can get propagation back
> into /mnt, due to the fact that a bind mount makes the new mount part
> of the old peer group.  This is the security hole that is fixed, and
> AFAICS the only security hole related to propagation vs. user mounts.
> 
> (I'm going to be offline tomorrow and the weekend, but will hopefully
> have email access next week).
> 
> Thanks,
> Miklos

(&(*$&%, you're right, of course.

Ok, will play with it a bit more, but I think it'd be *great* to see
this show up in -mm again.

-serge
