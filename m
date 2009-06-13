Return-Path: <linux-kernel-owner+w=401wt.eu-S1760943AbZFMXE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760943AbZFMXE6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 19:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbZFMXEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 19:04:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:57420 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbZFMXEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 19:04:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Marco <marco.stornelli@gmail.com>
Subject: Re: [PATCH 04/14] Pramfs: Mounting as root filesystem
Date: Sun, 14 Jun 2009 01:04:42 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
References: <4A33A7D7.3040008@gmail.com>
In-Reply-To: <4A33A7D7.3040008@gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200906140104.43463.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+U0J1efgDJ+HwVVnI9VvsqXkOO/xxJRXDy063
 Bb9EaoXtuRmA0KHyK+kKrg+L+ZBUHS+SGPnte1bpCp+FWjbIUY
 clmQhmgaAckwmDLcL1Gfn6g9GoRpSsZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 13 June 2009, Marco wrote:
>  void __init mount_root(void)
>  {
> +#ifdef CONFIG_ROOT_PRAMFS
> +       if (MAJOR(ROOT_DEV) == MEM_MAJOR) {
> +               if (mount_pramfs_root())
> +                       return;
> +
> +               printk(KERN_ERR "VFS: Unable to mount root fs via PRAMFS, trying floppy.\n");
> +               ROOT_DEV = Root_FD0;
> +       }
> +#endif

AFAICT, this will prevent booting from /dev/ram0 with a regular file system,
because that also uses MAJOR(ROOT_DEV) == 1.

	Arnd <><
