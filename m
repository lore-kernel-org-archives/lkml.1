Return-Path: <linux-kernel-owner+w=401wt.eu-S1753006AbZH1Tx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbZH1Tx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 15:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbZH1Tx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 15:53:56 -0400
Received: from thinkula.hx3.notconnected.net ([192.207.141.44]:52824 "EHLO
	sardonic.codimension.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510AbZH1Tx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 15:53:56 -0400
X-Greylist: delayed 496 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Aug 2009 15:53:55 EDT
Message-ID: <4A9833D3.3040202@code.wastedcycles.net>
Date: Fri, 28 Aug 2009 20:45:23 +0100
From: Jeff Smith <lkml.sepix@code.wastedcycles.net>
Reply-To: lkml.sepix@code.wastedcycles.net
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [kmemcheck] WARNING: kmemcheck: Caught 32-bit read from uninitialized
 memory, in  hid_output_report 
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A kmemcheck warning on booting my 2.6.31-rc8 (I haven't tried previous versions -- this was 
actually not the problem I set out to fix).

I can send Jiri (Bcc'ed) or the list a .config if it will help.

Jeff

WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (f6626624)
0100000001000000000000000000000000000000000000000000000000000000
 i u u u u u u u u u u u u u u u u u u u u u u u u u u u u u u u
         ^

Pid: 1, comm: swapper Not tainted (2.6.31-rc8-MOAT51 #2) ProLiant ML110 G5
EIP: 0060:[<c16e8d31>] EFLAGS: 00010046 CPU: 0
EIP is at hid_output_report+0x181/0x310
EAX: 00000001 EBX: ffffffff ECX: 00000000 EDX: 00000001
ESI: f6626620 EDI: 00000000 EBP: f711fc4c ESP: c1db160c
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: f676d4fc CR3: 01da4000 CR4: 00002650
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff4ff0 DR7: 00000400
 [<c16f39cd>] __usbhid_submit_report+0x12d/0x290
 [<c16f3b68>] usbhid_submit_report+0x38/0x50
 [<c16f3d1c>] usbhid_set_leds+0x9c/0xd0
 [<c16f44a7>] usbhid_start+0x627/0x670
 [<c16e93c2>] hid_device_probe+0x82/0xd0
 [<c14ca5dd>] driver_probe_device+0x6d/0x180
 [<c14ca7d1>] __device_attach+0x41/0x50
 [<c14c9bbb>] bus_for_each_drv+0x5b/0x80
 [<c14ca873>] device_attach+0x63/0x70
 [<c14c9997>] bus_attach_device+0x47/0x70
 [<c14c8219>] device_add+0x539/0x680
 [<c16e9025>] hid_add_device+0x165/0x1d0
 [<c16f2cd9>] hid_probe+0x269/0x3d0
 [<c165b006>] usb_probe_interface+0x86/0x140
 [<c14ca5dd>] driver_probe_device+0x6d/0x180
 [<c14ca781>] __driver_attach+0x91/0xa0
 [<c14c9e9b>] bus_for_each_dev+0x5b/0x80
 [<c14ca479>] driver_attach+0x19/0x20
 [<c14c97d7>] bus_add_driver+0x247/0x300
 [<c14caa15>] driver_register+0x75/0x170
 [<c165ae07>] usb_register_driver+0x87/0x110
 [<c1d42fbf>] hid_init+0x9f/0xc2
 [<c1001033>] do_one_initcall+0x23/0x190
 [<c1d0d345>] kernel_init+0x144/0x19d
 [<c1025cc7>] kernel_thread_helper+0x7/0x10
 [<ffffffff>] 0xffffffff
