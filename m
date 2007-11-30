Return-Path: <linux-kernel-owner+w=401wt.eu-S934325AbXK3Awy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934325AbXK3Awy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 19:52:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932807AbXK3Awr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 19:52:47 -0500
Received: from mail.suse.de ([195.135.220.2]:37158 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932728AbXK3Awq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 19:52:46 -0500
From: Neil Brown <neilb@suse.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 30 Nov 2007 11:52:36 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18255.24276.519113.975347@notabene.brown>
Cc: a.p.zijlstra@chello.nl, fengguang.wu@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] bdi patches
In-Reply-To: message from Miklos Szeredi on Thursday November 29
References: <E1IxhHk-00017y-Vp@dorka.pomaz.szeredi.hu>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday November 29, miklos@szeredi.hu wrote:
> > http://programming.kicks-ass.net/kernel-patches/foo/
> > 
> > bdi-task-dirty.patch
> > bdi-sysfs.patch
> > bdi-min.patch
> > bdi-max.patch
> > 
> > 
> > Is my current rather experimental stack, I just wrote the max part after
> > having slept on it. I'm not fond of the multiplication there, but I
> > dno't see a way around it.
> > 
> > Compile tested only.
> 
> I've done some testing on these patches and did some changes. So here
> they go.
> 
> Thanks,
> Miklos
> 
> ---------
> Subject: mm: sysfs: expose the BDI object in sysfs
> 
> Provide a place in sysfs for the backing_dev_info object.
> This allows us to see and set the various BDI specific variables.

You don't say what the place is, and I'm not quite familiar enough
with sysfs internals to figure it out my self.  Help?

And while I was looking I noticed that bdi_register (and bdi_init_fmt)
takes a second argument 'parent', which is always NULL, and which is
undocumented as to purpose.
If no-one would ever add another call to bdi_register, why have the
second arg, and if they might, how would they know what to put there?

Finally, the omission of NFS bothers me - and makes me wonder if the
choice of name in sysfs is appropriate.

Would a program ever want to generate the name (in sysfs) for a
particular bdi?  If so, how would it do it.

It seems to me after a fairly quick look that a bdi is always
associated with a device number.  For block devices the device number
is obvious.  For NFS and FUSE, the device number is an anon device
number allocated at mount time.
Maybe the name of the bdi should be based on that number.  Then it
would be possible to map directly from e.g. a file to the bdi that the
file would be written to. 

NeilBrown
