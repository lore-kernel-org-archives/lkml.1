Return-Path: <linux-kernel-owner+w=401wt.eu-S1754846AbZDLG20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbZDLG20 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 02:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753736AbZDLG2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 02:28:17 -0400
Received: from mail.bencastricum.nl ([213.84.203.196]:43590 "EHLO
	bencastricum.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622AbZDLG2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 02:28:16 -0400
X-Greylist: delayed 473 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Apr 2009 02:28:16 EDT
Message-ID: <8D207FA0B5B5443FAA8178A23C6CA5B9@Seven>
From: "Ben Castricum" <lk0904@bencastricum.nl>
To: <linux-kernel@vger.kernel.org>
Subject: 2.6.30-rc1 problems with firmware loading
Date: Sun, 12 Apr 2009 08:20:21 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I seem to have some problems with firmware loading since 2.6.30-rc1. Each 
request seems to time out and reports like these are appearing:

------------[ cut here ]------------
WARNING: at include/linux/security.h:1889 
security_vm_enough_memory+0x26/0x41()
Hardware name: HP d530 SFF(PL110ES)
Modules linked in: tg3 firmware_class libphy cdc_acm uhci_hcd ehci_hcd 
usbcore lm85 hwmon_vid hwmon i2c_i801 softdog rtc ext4 jbd2 crc16
Pid: 1105, comm: khelper Not tainted 2.6.30-rc1-00204-gb0cbc86 #229
Call Trace:
 [<b0124415>] warn_slowpath+0x71/0xa8
 [<b014b90e>] ? get_page_from_freelist+0x2f0/0x36c
 [<b014babf>] ? __alloc_pages_internal+0x96/0x369
 [<b014dcf3>] ? lru_cache_add_lru+0x27/0x29
 [<b015c7d9>] ? page_add_new_anon_rmap+0x58/0x65
 [<b015951d>] security_vm_enough_memory+0x26/0x41
 [<b01598cb>] expand_downwards+0x9f/0xf9
 [<b015995e>] find_extend_vma+0x2f/0x51
 [<b0157397>] __get_user_pages+0x6e/0x29e
 [<b01575f0>] get_user_pages+0x29/0x30
 [<b0168faa>] get_arg_page+0x2d/0x80
 [<b01690c0>] copy_strings+0xc3/0x160
 [<b016a21e>] do_execve+0x1ca/0x31a
 [<b0101621>] sys_execve+0x26/0x53
 [<b0102935>] syscall_call+0x7/0xb
 [<b011007b>] ? lapic_resume+0x79/0x1de
 [<b0105beb>] ? kernel_execve+0x17/0x1c
 [<b012ff5b>] ? ____call_usermodehelper+0x0/0x118
 [<b0130069>] ? ____call_usermodehelper+0x10e/0x118
 [<b012ff5b>] ? ____call_usermodehelper+0x0/0x118
 [<b010330f>] ? kernel_thread_helper+0x7/0x10
---[ end trace 76b9b878a630753f ]---
------------[ cut here ]------------
WARNING: at include/linux/security.h:1889 
security_vm_enough_memory+0x26/0x41()
Hardware name: HP d530 SFF(PL110ES)
Modules linked in: tg3 firmware_class libphy cdc_acm uhci_hcd ehci_hcd 
usbcore lm85 hwmon_vid hwmon i2c_i801 softdog rtc ext4 jbd2 crc16
Pid: 1105, comm: khelper Tainted: G        W  2.6.30-rc1-00204-gb0cbc86 #229
Call Trace:
 [<b0124415>] warn_slowpath+0x71/0xa8
 [<b0117d00>] ? kmap_atomic_to_page+0x12/0x4e
 [<b014b90e>] ? get_page_from_freelist+0x2f0/0x36c
 [<b014babf>] ? __alloc_pages_internal+0x96/0x369
 [<b015951d>] security_vm_enough_memory+0x26/0x41
 [<b01598cb>] expand_downwards+0x9f/0xf9
 [<b015995e>] find_extend_vma+0x2f/0x51
 [<b0157397>] __get_user_pages+0x6e/0x29e
 [<b01575f0>] get_user_pages+0x29/0x30
 [<b0168faa>] get_arg_page+0x2d/0x80
 [<b01690c0>] copy_strings+0xc3/0x160
 [<b016a21e>] do_execve+0x1ca/0x31a
 [<b0101621>] sys_execve+0x26/0x53
 [<b0102935>] syscall_call+0x7/0xb
 [<b011007b>] ? lapic_resume+0x79/0x1de
 [<b0105beb>] ? kernel_execve+0x17/0x1c
 [<b012ff5b>] ? ____call_usermodehelper+0x0/0x118
 [<b0130069>] ? ____call_usermodehelper+0x10e/0x118
 [<b012ff5b>] ? ____call_usermodehelper+0x0/0x118
 [<b010330f>] ? kernel_thread_helper+0x7/0x10
---[ end trace 76b9b878a6307540 ]---

hope this helps. 

