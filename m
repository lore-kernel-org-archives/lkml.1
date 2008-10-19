Return-Path: <linux-kernel-owner+w=401wt.eu-S1751932AbYJSSNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbYJSSNB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 14:13:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751590AbYJSSMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 14:12:52 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:38005 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbYJSSMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 14:12:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=c1l+T5Oq2d6tQXMjMQobcrf9qKW86+95UZRlQtWu1rsvvsDrg/salOWA/vKUBLYSLg
         p/q4l6A2V4BlwZqr9goPzZ4UcKPMbVX1b4lHBteLph3CXnjWyFccxAhyW32ONyldIo/f
         yo++B4Z7vjiFzZozBVIzjf1Geb+GOcDH27364=
Message-ID: <8bd0f97a0810191112v29ca6be9kf4b0b8ecca718ef8@mail.gmail.com>
Date: Sun, 19 Oct 2008 14:12:51 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Bodo Eggert" <7eggert@gmx.de>
Subject: Re: [PATCH] use tmpfs for rootfs v3
Cc: jeffschroeder@computer.org, "Geert Uytterhoeven" <geert@linux-m68k.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LSU.0.999.0810171313550.4828@be1.lrz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LSU.0.999.0810161400160.5456@be1.lrz>
	 <Pine.LNX.4.64.0810161507130.25933@anakin>
	 <alpine.LSU.0.999.0810161936590.5051@be1.lrz>
	 <c24352ca0810161403r1842185bg2f8b4f8c067af541@mail.gmail.com>
	 <alpine.LSU.0.999.0810171313550.4828@be1.lrz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 07:16, Bodo Eggert wrote:
> This patch allows chosing tmpfs instead of ramfs for the root filesystem.
> Having tmpfs is usefull for running systems from RAM, because it does not
> risk deadlocking the system and possibly allows swapping. Using tmpfs
> increases the kernel by 10 bytes on x86_64.

great option, thanks

> --- linux-2.6.27.2-numlock/fs/Kconfig   2008-10-10 13:18:34.000000000 +0200
> +++ linux-2.6.27.3-tmpfs/fs/Kconfig     2008-10-11 15:42:21.000000000 +0200
> @@ -953,6 +953,27 @@ config TMPFS_POSIX_ACL
>
>          If you don't know what Access Control Lists are, say N.
>
> +config TMPFS_ROOT
> +       bool "Use tmpfs instrad of ramfs for initramfs"
> +       depends on TMPFS && SHMEM
> +       default n
> +       help
> +         This replaces the ramfs used for unpacking the cpio images
> +         with tmpfs.
> +
> +         If unsure, say N

this should be init/Kconfig and depend on BLK_DEV_INITRD i think.  and
then update the comment to talk about the initial filesystem rather
than cpio images.

> +config RAMFS
> +       bool "Ramfs file system support" if TMPFS_ROOT

if you have initramfs support disabled, then you should be able to
disable RAMFS as well.  so perhaps the depend should read like:
if BLK_DEV_INITRD && TMPFS_ROOT || !BLK_DEV_INITRD
-mike
