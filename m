Return-Path: <linux-kernel-owner+w=401wt.eu-S1756179AbXIYPDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbXIYPDM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 11:03:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753460AbXIYPC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 11:02:56 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:16814 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbXIYPCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 11:02:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=E96Aki129FYq7dS7yip4Ca+ETIKoMcwBxdAOwc+i4LILp33ygXIdi40yzrdECABLHkUhhBnB2ZFgebZqXWfE+k5eFmfEUwqZoTdSvzgfxoAklX4IzoXSyB7QXPryaoGGmhUvgp0FqZ/SXeXmkSV2MzN74DO+jgLmZf6cyBl4xBs=
Date: Tue, 25 Sep 2007 23:02:40 +0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mark@mtfhpc.demon.co.uk
Subject: 2.6.23-rc8-mm1: unscrew UFS
Message-ID: <20070925190240.GA1809@martell.zuzino.mipt.ru>
References: <20070925014625.3cd5f896.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070925014625.3cd5f896.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dereferencing unintialized "usb3" pointer in ufs_fill_super() is not
going to work. gcc even warns about this.

BUG: unable to handle kernel NULL pointer dereference at virtual address 0000014e
printing eip: f9a3b1a2 *pde = 00000000 
Oops: 0000 [#1] PREEMPT 
last sysfs file: /block/loop7/removable
Modules linked in: ufs loop usbhid ehci_hcd snd_intel8x0 snd_ac97_codec uhci_hcd rtc ac97_bus usbcore thermal button processor sr_mod evdev cdrom

Pid: 1066, comm: mount Not tainted (2.6.23-rc8-mm1 #1)
EIP: 0060:[<f9a3b1a2>] EFLAGS: 00010286 CPU: 0
EIP is at ufs_fill_super+0x52f/0x12e5 [ufs]
EAX: 00000002 EBX: c39c4960 ECX: c0176465 EDX: 00000000
ESI: c38c5000 EDI: c387f800 EBP: 00000600 ESP: c3816d3c
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process mount (pid: 1066, ti=c3816000 task=c38f34d0 task.ti=c3816000)
last branch before last exception/interrupt
 from c0130fc0 (lockdep_on+0xb/0xc)
 to c0118d82 (vprintk+0x29f/0x2fb)
Stack: 00000010 00000000 00000600 00000000 c3816db4 0038c0d8 00000000 c3816dd4 
       ffffffff 00000002 00000200 00000600 00002130 00002000 c39c4960 c01b1355 
       c3816d94 c3816d94 c0187966 c3816db4 00000020 c0347b9b c280680c 00000400 
Call Trace:
 [<c01b1355>] snprintf+0x1f/0x22
 [<c0187966>] disk_name+0x79/0x83
 [<c015c49b>] get_sb_bdev+0xdc/0x11a
 [<c016ca6d>] alloc_vfsmnt+0x8d/0xb3
 [<f9a39e3c>] ufs_get_sb+0x20/0x25 [ufs]
 [<f9a3ac73>] ufs_fill_super+0x0/0x12e5 [ufs]
 [<c015c09c>] vfs_kern_mount+0x40/0x79
 [<c016d601>] do_mount+0x6c0/0x7e3
 [<c02c82a3>] _spin_unlock+0x25/0x3b
 [<c01318dc>] mark_held_locks+0x39/0x53
 [<c013fd1d>] find_lock_page+0xf/0x84
 [<c014456f>] get_page_from_freelist+0x21e/0x3f0
 [<c0131ab0>] trace_hardirqs_on+0x118/0x13b
 [<c0144599>] get_page_from_freelist+0x248/0x3f0
 [<c01582f1>] kmem_cache_alloc+0x68/0x9b
 [<c016be18>] copy_mount_options+0x26/0x109
 [<c016d79b>] sys_mount+0x77/0xb3
 [<c0103db2>] sysenter_past_esp+0x5f/0x99
 =======================
INFO: lockdep is turned off.
Code: d2 f7 74 24 28 03 87 50 01 00 00 89 04 24 c7 44 24 04 00 00 00 00 89 f2 89 f8 e8 e6 2b 00 00 85 c0 0f 84 1e 0d 00 00 8b 44 24 24 <8b> 90 4c 01 00 00 8b 86 58 02 00 00 83 78 08 00 74 02 0f ca 89 
EIP: [<f9a3b1a2>] ufs_fill_super+0x52f/0x12e5 [ufs] SS:ESP 0068:c3816d3c

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/ufs/super.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -837,6 +837,10 @@ again:
 	if (!ubh) 
             goto failed;
 
+	usb1 = ubh_get_usb_first(uspi);
+	usb2 = ubh_get_usb_second(uspi);
+	usb3 = ubh_get_usb_third(uspi);
+
 	/* Sort out mod used on SunOS 4.1.3 for fs_state */
 	uspi->s_postblformat = fs32_to_cpu(sb, usb3->fs_postblformat);
 	if (((flags & UFS_ST_MASK) == UFS_ST_SUNOS) &&
@@ -845,11 +849,6 @@ again:
 		flags |=  UFS_ST_SUN;
 	}
 
-	
-	usb1 = ubh_get_usb_first(uspi);
-	usb2 = ubh_get_usb_second(uspi);
-	usb3 = ubh_get_usb_third(uspi);
-
 	/*
 	 * Check ufs magic number
 	 */
