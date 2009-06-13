Return-Path: <linux-kernel-owner+w=401wt.eu-S1754983AbZFMIyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983AbZFMIyV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 04:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbZFMIyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 04:54:10 -0400
Received: from mail.bencastricum.nl ([213.84.203.196]:54643 "EHLO
	bencastricum.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbZFMIyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 04:54:08 -0400
X-Greylist: delayed 597 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Jun 2009 04:54:07 EDT
Message-ID: <89016FA471B043A8878691AD2C7682CF@Seven>
From: "Ben Castricum" <mail0906@bencastricum.nl>
To: <linux-kernel@vger.kernel.org>
Subject: OOPS in 2.6.30-03217-gf3ad116 / unable to handle kernel NULL pointer dereference at 00000004
Date: Sat, 13 Jun 2009 10:47:17 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I got this since I just pulled the current tree. 2.6.30-rc8 didn't had this 
problem.

My config can be found at http://www.bencastricum.nl/.config

Hope this helps.
Ben


BUG: unable to handle kernel NULL pointer dereference at 00000004
IP: [<b0132318>] finish_wait+0x30/0x49
*pde = 00000000
Oops: 0002 [#1] SMP
last sysfs file: /sys/devices/platform/microcode/firmware/microcode/loading
Modules linked in: ipt_MASQUERADE ipt_REJECT ipt_LOG xt_recent xt_tcpudp 
xt_state iptable_filter nf_conntrack_ftp iptable_nat ip_tables nf_nat 
x_tables nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 af_packet 8139too mii 
tg3 firmware_class libphy cdc_acm uhci_hcd ehci_hcd usbcore lm85 hwmon_vid 
hwmon i2c_i801 softdog rtc ext4 jbd2 crc16 [last unloaded: microcode]

Pid: 1662, comm: cid Not tainted (2.6.30-03217-gf3ad116 #266) HP d530 
SFF(PL110ES)
EIP: 0060:[<b0132318>] EFLAGS: 00010046 CPU: 0
EIP is at finish_wait+0x30/0x49
EAX: 00000217 EBX: ee89bdf8 ECX: 00000000 EDX: 00000000
ESI: ee89be04 EDI: ef056820 EBP: ee89bdd0 ESP: ee89bdc4
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process cid (pid: 1662, ti=ee89b000 task=edd3d320 task.ti=ee89b000)
Stack:
 ef05680c ef056820 fffffe00 ee89be18 b020a2c4 edc31300 eeb96000 ef056814
 00000086 00000246 ef056954 ef056954 ee89bdfc 00000000 edd3d320 b0120645
 00000000 00000000 ef056800 ef056954 ef056954 ee89be44 f3b21cb0 edc31300
Call Trace:
 [<b020a2c4>] ? tty_port_block_til_ready+0x1a5/0x1e0
 [<b0120645>] ? default_wake_function+0x0/0xd
 [<f3b21cb0>] ? acm_tty_open+0x1ef/0x24b [cdc_acm]
 [<b020578c>] ? tty_open+0x280/0x380
 [<b0168c4a>] ? chrdev_open+0x125/0x13c
 [<b016557f>] ? __dentry_open+0x109/0x1f7
 [<b0165707>] ? nameidata_to_filp+0x2c/0x43
 [<b0168b25>] ? chrdev_open+0x0/0x13c
 [<b016ee80>] ? do_filp_open+0x3b9/0x6db
 [<b0156977>] ? handle_mm_fault+0x1fa/0x451
 [<b01768a7>] ? alloc_fd+0x5b/0xcd
 [<b016539c>] ? do_sys_open+0x44/0xbf
 [<b0165459>] ? sys_open+0x1e/0x26
 [<b0102848>] ? sysenter_do_call+0x12/0x26
Code: 53 89 c7 89 d3 64 a1 00 90 3c b0 c7 00 00 00 00 00 8d 72 0c 39 72 0c 
75 05 3b 72 10 74 21 89 f8 e8 3a a2 17 00 8b 4b 0c 8b 53 10 <89> 51 04 89 0a 
89 73 0c 89 73 10 89 c2 89 f8 e8 f1 a2 17 00 5b
EIP: [<b0132318>] finish_wait+0x30/0x49 SS:ESP 0068:ee89bdc4
CR2: 0000000000000004
---[ end trace 95ef613d9edaca65 ]--- 

