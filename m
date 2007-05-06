Return-Path: <linux-kernel-owner+w=401wt.eu-S933587AbXEFKVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933587AbXEFKVx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 06:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933591AbXEFKVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 06:21:53 -0400
Received: from frankvm.xs4all.nl ([80.126.170.174]:47137 "EHLO
	janus.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933587AbXEFKVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 06:21:52 -0400
Date: Sun, 6 May 2007 12:21:51 +0200
From: Frank van Maarseveen <frankvm@frankvm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: lkml123@s2y4n2c.de, linux-kernel@vger.kernel.org
Subject: Re: unprivileged mount problems: device permissions ignored, mount sharing
Message-ID: <20070506102150.GA20740@janus>
References: <1177873151.4343.29.camel@segv.aura.of.mankind> <E1Hj9hk-00019p-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Hj9hk-00019p-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.1i
X-BotBait: val@frankvm.com, kuil@frankvm.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 09:56:52AM +0200, Miklos Szeredi wrote:
> > I tried the unprivileged mount v5 patches with 2.6.21.1. I made some
> > experiments with normal filesystems (ext3, xfs, iso9660). I removed the
> > FS_SAFE checks for that.
> 
> Thanks for looking at this.
> 
> > Mounting and umounting as unprivileged user (user1) works, e.g.
> > (/mnt/user1 is a mount owned by user1)
> > 
> > [user1@segv ~]$ mmount -t xfs /dev/mapper/vg00-test /mnt/user1
> > 
> > But the device permissions are ignored. The unprivileged user can mount
> > the block device even there are no permissions to access it:
> > 
> > brw------- 1 root root 253, 5 Apr 29 18:32 /dev/mapper/vg00-test
> 
> Yes, I'm aware of this.  Before we enable FS_SAFE for block
> filesystems, this must be addressed.
> 
> But I'm not sure _if_ we'll ever want this.  It is very likely that
> there are some other security holes in most filesystems that are
> difficult to address.  One example is checking for hard-linked
> directories, which is normally only done during an fsck.

Some filesystems are not hardened against mounting a corrupted image and
can Oops. This is also a problem for automounting USB sticks except that
in that case you're (probably) sitting next to the hardware so there
are other ways to do bad things.

>From a security point of view I'd like to restrict unprivileged mounts
to a configurable list of filesystem types.

-- 
Frank
