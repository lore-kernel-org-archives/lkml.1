Return-Path: <linux-kernel-owner+w=401wt.eu-S1754432AbYJTSNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432AbYJTSNc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 14:13:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753351AbYJTSNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 14:13:21 -0400
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:41476 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753316AbYJTSNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 14:13:20 -0400
Date: Mon, 20 Oct 2008 20:13:09 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: Mike Frysinger <vapier.adi@gmail.com>
cc: Bodo Eggert <7eggert@gmx.de>, jeffschroeder@computer.org,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use tmpfs for rootfs v3
In-Reply-To: <8bd0f97a0810191112v29ca6be9kf4b0b8ecca718ef8@mail.gmail.com>
Message-ID: <alpine.LSU.0.999.0810202006050.5225@be1.lrz>
References: <alpine.LSU.0.999.0810161400160.5456@be1.lrz> 
 <Pine.LNX.4.64.0810161507130.25933@anakin>  <alpine.LSU.0.999.0810161936590.5051@be1.lrz>
  <c24352ca0810161403r1842185bg2f8b4f8c067af541@mail.gmail.com> 
 <alpine.LSU.0.999.0810171313550.4828@be1.lrz>
 <8bd0f97a0810191112v29ca6be9kf4b0b8ecca718ef8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Oct 2008, Mike Frysinger wrote:
> On Fri, Oct 17, 2008 at 07:16, Bodo Eggert wrote:

> > This patch allows chosing tmpfs instead of ramfs for the root filesystem.
> > Having tmpfs is usefull for running systems from RAM, because it does not
> > risk deadlocking the system and possibly allows swapping. Using tmpfs
> > increases the kernel by 10 bytes on x86_64.
> 
> great option, thanks
> 
> > --- linux-2.6.27.2-numlock/fs/Kconfig   2008-10-10 13:18:34.000000000 +0200
> > +++ linux-2.6.27.3-tmpfs/fs/Kconfig     2008-10-11 15:42:21.000000000 +0200
> > @@ -953,6 +953,27 @@ config TMPFS_POSIX_ACL
> >
> >          If you don't know what Access Control Lists are, say N.
> >
> > +config TMPFS_ROOT
> > +       bool "Use tmpfs instrad of ramfs for initramfs"
> > +       depends on TMPFS && SHMEM
> > +       default n
> > +       help
> > +         This replaces the ramfs used for unpacking the cpio images
> > +         with tmpfs.
> > +
> > +         If unsure, say N
> 
> this should be init/Kconfig and depend on BLK_DEV_INITRD i think.  and
> then update the comment to talk about the initial filesystem rather
> than cpio images.

Maybe, but then you'd have to go to filesystems->pseudo-fs to enable tmpfs,
then to i-don't-remember to set it as the rootfs, and then back to
fs->pseudo-fs to unselect ramfs.

Thinking of it as a tmpfs option makes it much easier to use.

> > +config RAMFS
> > +       bool "Ramfs file system support" if TMPFS_ROOT
> 
> if you have initramfs support disabled, then you should be able to
> disable RAMFS as well.  so perhaps the depend should read like:
> if BLK_DEV_INITRD && TMPFS_ROOT || !BLK_DEV_INITRD

No, since a kernel not having initcpio support will mount rootfs anyway,
create some directories and special files and use them to open the console
and to mount the real root into.
-- 
The enemy diversion you have been ignoring will be the main attack.
