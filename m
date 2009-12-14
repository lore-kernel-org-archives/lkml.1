Return-Path: <linux-kernel-owner+w=401wt.eu-S1757113AbZLNMJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113AbZLNMJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 07:09:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757093AbZLNMJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 07:09:31 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:64119 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757080AbZLNMJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 07:09:30 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the md-current tree with Linus' tree
Date: Mon, 14 Dec 2009 11:27:26 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Neil Brown <neilb@suse.de>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20091214102428.f50557a0.sfr@canb.auug.org.au>
In-Reply-To: <20091214102428.f50557a0.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912141127.27019.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+DN4XOKqfc5/I7roZxT+QNwPYnTd9MIIVy0AO
 Mx8Yx4ibe4J7/coHBNGctwM3d3Kel2wock0eZwtZVZ1cGq8lfy
 BqTgZUrZBT7gZd7v1zfSw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 December 2009, Stephen Rothwell wrote:
> index 278020d,ad485ba..0000000
> --- a/fs/compat_ioctl.c
> +++ b/fs/compat_ioctl.c
> @@@ -979,29 -1912,22 +979,11 @@@ COMPATIBLE_IOCTL(FIGETBSZ
>   /* 'X' - originally XFS but some now in the VFS */
>   COMPATIBLE_IOCTL(FIFREEZE)
>   COMPATIBLE_IOCTL(FITHAW)
> - /* RAID */
> - COMPATIBLE_IOCTL(RAID_VERSION)
> - COMPATIBLE_IOCTL(GET_ARRAY_INFO)
> - COMPATIBLE_IOCTL(GET_DISK_INFO)
> - COMPATIBLE_IOCTL(PRINT_RAID_DEBUG)
> - COMPATIBLE_IOCTL(RAID_AUTORUN)
> - COMPATIBLE_IOCTL(CLEAR_ARRAY)
> - COMPATIBLE_IOCTL(ADD_NEW_DISK)
> - COMPATIBLE_IOCTL(SET_ARRAY_INFO)
> - COMPATIBLE_IOCTL(SET_DISK_INFO)
> - COMPATIBLE_IOCTL(WRITE_RAID_INFO)
> - COMPATIBLE_IOCTL(UNPROTECT_ARRAY)
> - COMPATIBLE_IOCTL(PROTECT_ARRAY)
> - COMPATIBLE_IOCTL(RUN_ARRAY)
> - COMPATIBLE_IOCTL(STOP_ARRAY)
> - COMPATIBLE_IOCTL(STOP_ARRAY_RO)
> - COMPATIBLE_IOCTL(RESTART_ARRAY_RW)
> - COMPATIBLE_IOCTL(GET_BITMAP_FILE)
>  -/* Big K */
>  -COMPATIBLE_IOCTL(PIO_FONT)
>  -COMPATIBLE_IOCTL(GIO_FONT)
>  -COMPATIBLE_IOCTL(PIO_CMAP)
>  -COMPATIBLE_IOCTL(GIO_CMAP)
>  -ULONG_IOCTL(KDSIGACCEPT)
>   COMPATIBLE_IOCTL(KDGETKEYCODE)
>   COMPATIBLE_IOCTL(KDSETKEYCODE)
>  -ULONG_IOCTL(KIOCSOUND)
>  -ULONG_IOCTL(KDMKTONE)
>   COMPATIBLE_IOCTL(KDGKBTYPE)
>  -ULONG_IOCTL(KDSETMODE)
>   COMPATIBLE_IOCTL(KDGETMODE)
>  -ULONG_IOCTL(KDSKBMODE)
>   COMPATIBLE_IOCTL(KDGKBMODE)
>  -ULONG_IOCTL(KDSKBMETA)
>   COMPATIBLE_IOCTL(KDGKBMETA)
>   COMPATIBLE_IOCTL(KDGKBENT)
>   COMPATIBLE_IOCTL(KDSKBENT)

This merge is incomplete, because the patch that I made for Neil
removes the handling for HOT_REMOVE_DISK, HOT_ADD_DISK,
SET_DISK_FAULTY and SET_BITMAP_FILE from fs/compat_ioctl.c
along with the others above, while my other patch that Linus
merged moves them into the switch statement in do_ioctl_trans.

Neil, still have  a tree where I track patches to fs/compat_ioctl.c
that have not yet been merged. If you just keep the half in your
own files and drop the ones in fs/compat_ioctl.c, I'll submit that
next time. You can also adapt the patch again to the new contents
and remove the four above to save me that work.

I didn't want to remove them from fs/compat_ioctl.c before they
got added to md.c, in order to keep bisection correct.

	Arnd
