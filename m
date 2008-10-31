Return-Path: <linux-kernel-owner+w=401wt.eu-S1753338AbYJaDzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbYJaDzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 23:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751430AbYJaDzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 23:55:04 -0400
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:3857 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbYJaDzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 23:55:03 -0400
X-Greylist: delayed 541 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Oct 2008 23:55:02 EDT
Date: Fri, 31 Oct 2008 04:45:53 +0100
From: Jeroen Roovers <jer@gentoo.org>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-parisc@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: Re: 2.6.28-rc2: USB/INPUT: slab error in
 cache_alloc_debugcheck_after(): double free?
Message-ID: <20081031044553.50882e86@epia.jer-c2.orkz.net>
In-Reply-To: <200810310011.08618.deller@gmx.de>
References: <200810310011.08618.deller@gmx.de>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am seeing the same USB problem but without the SLAB errors - [1] is
the Gentoo bug report. The kernel boots fine with both USB keyboard and
mouse detached.


[17179609.760000] usb 1-2: configuration #1 chosen from 1 choice
[17179609.860000] input: Kensington Kensington USB/PS2 Trackball as
/class/inpu1
[17179609.972000] Backtrace:
[17179609.972000]  [<101daa9c>] sysfs_find_dirent+0x34/0x50
[17179609.972000]  [<101daad8>] __sysfs_add_one+0x20/0xc0
[17179609.972000]  [<101dab8c>] sysfs_add_one+0x14/0x50
[17179609.972000]  [<101db250>] create_dir+0x64/0xcc
[17179609.972000]  [<101db2e4>] sysfs_create_dir+0x2c/0x5c
[17179609.972000]  [<102f2cd0>] kobject_add_internal+0xb8/0x1b0
[17179609.972000]  [<102f326c>] kobject_add+0x38/0x68
[17179609.972000]  [<1035b2b0>] device_add+0xdc/0x55c
[17179609.972000]  [<103d6930>] mousedev_create+0x17c/0x1f8
[17179609.972000]  [<103d7284>] mousedev_connect+0x48/0x138
[17179609.972000]  [<103d2b50>] input_attach_handler+0x6c/0xac
[17179609.972000]  [<103d5014>] input_register_device+0x1a4/0x250
[17179609.972000]  [<103dfe08>] hidinput_connect+0x308/0x3b40
[17179609.972000]  [<103de5d4>] hid_connect+0x22c/0x2c0
[17179609.972000]  [<103de740>] hid_device_probe+0xd8/0xfc
[17179609.972000]  [<1035db94>] driver_probe_device+0xa4/0x198
[17179609.972000]
[17179609.972000]
[17179609.972000] Kernel Fault: Code=26 regs=8f86d0c0 (Addr=00000000)
[17179609.972000]
[17179609.972000]      YZrvWESTHLNXBCVMcbcbcbcbOGFRQPDI
[17179609.972000] PSW: 00000000000001001111111000001111 Not tainted
[17179609.972000] r00-03  0004fe0f 105a8e50 101daa9c 8ecef000
[17179609.972000] r04-07  8f8d4d70 fffffff4 8f296f60 8f86cf48
[17179609.972000] r08-11  8f297ac8 8ec37000 8f293e90 00000008
[17179609.972000] r12-15  00000006 00000001 00000002 00000003
[17179609.972000] r16-19  8ec37000 fffeffff fffeff70 00000073
[17179609.972000] r20-23  00000006 0000000f 000003e0 8f296f60
[17179609.972000] r24-27  101da714 8f8d4d70 00000000 105a8650
[17179609.972000] r28-31  8ecef000 156979c9 8f86d0c0 101a0274
[17179609.972000] sr00-03  00000000 00000000 00000000 0000000c
[17179609.972000] sr04-07  00000000 00000000 00000000 00000000
[17179609.972000]
[17179609.972000] IASQ: 00000000 00000000 IAOQ: 102f6a50 102f6a54
[17179609.972000]  IIR: 0f40101c    ISR: 00000000  IOR: 00000000
[17179609.972000]  CPU:        0   CR30: 8f86c000 CR31: 11111111
[17179609.972000]  ORIG_R28: 0000000f
[17179609.972000]  IAOQ[0]: strcmp+0x0/0x34
[17179609.972000]  IAOQ[1]: strcmp+0x4/0x34
[17179609.972000]  RP(r2): sysfs_find_dirent+0x34/0x50
[17179609.972000] Backtrace:
[17179609.972000]  [<101daa9c>] sysfs_find_dirent+0x34/0x50
[17179609.972000]  [<101daad8>] __sysfs_add_one+0x20/0xc0
[17179609.972000]  [<101dab8c>] sysfs_add_one+0x14/0x50
[17179609.972000]  [<101db250>] create_dir+0x64/0xcc
[17179609.972000]  [<101db2e4>] sysfs_create_dir+0x2c/0x5c
[17179609.972000]  [<102f2cd0>] kobject_add_internal+0xb8/0x1b0
[17179609.972000]  [<102f326c>] kobject_add+0x38/0x68
[17179609.972000]  [<1035b2b0>] device_add+0xdc/0x55c
[17179609.972000]  [<103d6930>] mousedev_create+0x17c/0x1f8
[17179609.972000]  [<103d7284>] mousedev_connect+0x48/0x138
[17179609.972000]  [<103d2b50>] input_attach_handler+0x6c/0xac
[17179609.972000]  [<103d5014>] input_register_device+0x1a4/0x250
[17179609.972000]  [<103dfe08>] hidinput_connect+0x308/0x3b40
[17179609.972000]  [<103de5d4>] hid_connect+0x22c/0x2c0
[17179609.972000]  [<103de740>] hid_device_probe+0xd8/0xfc
[17179609.972000]  [<1035db94>] driver_probe_device+0xa4/0x198
[17179609.972000]
[17179609.972000] Kernel panic - not syncing: Kernel Fault


Kind regards,
     JeR


[1] https://bugs.gentoo.org/show_bug.cgi?id=245001
