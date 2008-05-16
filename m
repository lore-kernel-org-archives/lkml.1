Return-Path: <linux-kernel-owner+w=401wt.eu-S1758851AbYEPP23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851AbYEPP23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 11:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbYEPP2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 11:28:19 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:33593 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbYEPP2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 11:28:17 -0400
Date: Fri, 16 May 2008 17:28:16 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Junjiro Okajima <hooanon05@yahoo.co.jp>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/67] aufs configuration
In-Reply-To: <12109484013051-git-send-email-hooanon05@yahoo.co.jp>
Message-ID: <alpine.LNX.1.10.0805161720530.15590@fbirervta.pbzchgretzou.qr>
References: <12109484013324-git-send-email-hooanon05@yahoo.co.jp> <12109484012532-git-send-email-hooanon05@yahoo.co.jp> <12109484012997-git-send-email-hooanon05@yahoo.co.jp> <12109484013051-git-send-email-hooanon05@yahoo.co.jp>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2008-05-16 16:32, hooanon05@yahoo.co.jp wrote:
>+
>+if AUFS
>+config AUFS_FAKE_DM
>+	bool
>+	depends on AUFS
>+	default n

When you have "if AUFS" you do not need all the "depends on AUFS".

>+config AUFS_ROBR
>+	bool "Aufs as an readonly branch of another aufs"
>+	depends on AUFS
>+	default n
>+	help
>+	If you want make your aufs to be a part of another aufs, then
>+	enable this option. In other words, you can specify your aufs
>+	path in 'br:' mount option for another aufs, but cannot
>+	specify 'rw' as the branch permission.
>+	It will damage the performance.
>+	See detail in aufs.5.

IIRC, unionfs did not need such an option, so why does AUFS?

>+config AUFS_DLGT
>+	bool "Delegate the internal branch access the kernel thread"
>+	depends on AUFS
>+	default n

I do not think you need "default n" either as that should be the
implicit default.

>+config AUFS_SPLICE_PATCH
>+	bool
>+	depends on AUFS
>+	default y

This should just go away if it is always selected anyway.

>+config AUFS_BR_NFS
>+	bool
>+	depends on AUFS
>+	depends on NFS_FS
>+	depends on !AUFS_FAKE_DM
>+	default n if (!AUFS_LHASH_PATCH || AUFS_FAKE_DM)
>+	default y

One AUFS_FAKE_DM is redundant here. It should probably be just

	depends on NFS_FS && !AUFS_FAKE_DM && AUFS_LHASH_PATCH

>+config AUFS_BR_XFS
>+	bool
>+	depends on AUFS
>+	depends on XFS_FS
>+	default y

Same here, just depends on XFS_FS.

>+config AUFS_WORKAROUND_FUSE
>+	bool "Special handling for FUSE-based filesystem"
>+	depends on AUFS && FUSE_FS
>+	default n
>+	help
>+	A FUSE-based filesystem may not initialize its inode
>+	attributes and the FUSE developer thinks the inode attributes
>+	in a positive dentry which is returned by VFS lookup operation
>+	are not reliable.
>+	If you use a FUSE-based filesystem as an aufs branch, and it
>+	customizes the inode attribute on it without overriding
>+	fuse_lowlevel_ops.lookup, probably you need to enable this
>+	configuration.
>+	If you enable this configuration, aufs calls getattr operation
>+	in every lookup and revalidate operation for the FUSE-based
>+	filesystem branch.
>+	It will damage the performance even if you don't use a
>+	FUSE-based filesystem branch.

Performance is not "damaged" but "hurt"  :-) [or just "will negatively
impact performance"]

>+config AUFS_MAGIC_SYSRQ
>+	bool
>+	depends on AUFS
>+	depends on AUFS_DEBUG
>+	depends on MAGIC_SYSRQ
>+	default y

Since I see this for the first time, a bit of help text would not be
bad, even if it is not visible in menuconfig.

>+config AUFS_COMPAT
>+	bool "Compatibility with Unionfs (obsolete)"

If it is obsolete, it should not be merged.
