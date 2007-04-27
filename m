Return-Path: <linux-kernel-owner+w=401wt.eu-S1755513AbXD0JXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbXD0JXK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 05:23:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755514AbXD0JXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 05:23:10 -0400
Received: from mail1.vetienne.net ([87.98.219.23]:3195 "EHLO
	mail1.vetienne.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513AbXD0JXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 05:23:09 -0400
Message-ID: <010a01c788ae$0a7d0140$5601a8c0@apws2>
From: "VE \(HOME\)" <ve@vetienne.net>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>, <fubar@us.ibm.com>,
       <bonding-devel@lists.sourceforge.net>
References: <200704262058.33087.ve@vetienne.net> <20070426211146.f370cf81.akpm@linux-foundation.org>
Subject: Re: [PROBLEM] Bonding driver in linux-2.6.21-rc6-mm1
Date: Fri, 27 Apr 2007 11:25:46 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3028
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 26 Apr 2007 20:58:32 +0200 Vincent ETIENNE <ve@vetienne.net>
> wrote:
>
>
> This was due to locking bustage in the net tree.  It should be fixed
> in 2.6.21-rc7-mm2.

I have tried this version. Same problem ( see 
http://mail1.vetienne.net/linux/dmesg-2.6.21-rc7-mm2.log )
But also a new problem with USB keyboard/mouse

BUG: at drivers/hid/usbhid/hid-quirks.c:480 usbhid_exists_dquirk()

Call Trace:
[<ffffffff8044bbcb>] usbhid_lookup_quirk+0x63/0xea
[<ffffffff8044ab12>] hid_probe+0x4d/0xbad
[<ffffffff8021d7cd>] default_wake_function+0x0/0xe
[<ffffffff8029d0b6>] sysfs_new_dirent+0x79/0xaa
[<ffffffff80403411>] usb_match_one_id+0x26/0x82
[<ffffffff80403fe6>] usb_probe_interface+0x7d/0xa5
[<ffffffff80391cb9>] driver_probe_device+0xf6/0x17f
[<ffffffff80391de4>] __driver_attach+0x0/0x93
[<ffffffff80391e3e>] __driver_attach+0x5a/0x93
[<ffffffff8039110c>] bus_for_each_dev+0x43/0x6e
[<ffffffff80391433>] bus_add_driver+0x7b/0x19d
[<ffffffff80403b06>] usb_register_driver+0x7e/0xe1
[<ffffffff8064d2d3>] hid_init+0x28/0x4e
[<ffffffff8063460b>] kernel_init+0x162/0x2d2
[<ffffffff8020a338>] child_rip+0xa/0x12
[<ffffffff80343d5c>] acpi_ds_init_one_object+0x0/0x7c
[<ffffffff806344a9>] kernel_init+0x0/0x2d2
[<ffffffff8020a32e>] child_rip+0x0/0x12

input: ServerEngines SE USB Device as 
/devices/pci0000:00/0000:00:1d.2/usb4/4-2/4-2:1.0/input/input2
input: USB HID v1.11 Keyboard [ServerEngines SE USB Device] on 
usb-0000:00:1d.2-2
BUG: at drivers/hid/usbhid/hid-quirks.c:480 usbhid_exists_dquirk()

Call Trace:
[<ffffffff8044bbcb>] usbhid_lookup_quirk+0x63/0xea
[<ffffffff8044ab12>] hid_probe+0x4d/0xbad
[<ffffffff8029d0b6>] sysfs_new_dirent+0x79/0xaa
[<ffffffff80403411>] usb_match_one_id+0x26/0x82
[<ffffffff80403fe6>] usb_probe_interface+0x7d/0xa5
[<ffffffff80391cb9>] driver_probe_device+0xf6/0x17f
[<ffffffff80391de4>] __driver_attach+0x0/0x93
[<ffffffff80391e3e>] __driver_attach+0x5a/0x93
[<ffffffff8039110c>] bus_for_each_dev+0x43/0x6e
[<ffffffff80391433>] bus_add_driver+0x7b/0x19d
[<ffffffff80403b06>] usb_register_driver+0x7e/0xe1
[<ffffffff8064d2d3>] hid_init+0x28/0x4e
[<ffffffff8063460b>] kernel_init+0x162/0x2d2
[<ffffffff8020a338>] child_rip+0xa/0x12
[<ffffffff80343d5c>] acpi_ds_init_one_object+0x0/0x7c
[<ffffffff806344a9>] kernel_init+0x0/0x2d2
[<ffffffff8020a32e>] child_rip+0x0/0x12


And also a strange problem : dhcp server and dns server was started before 
bond0 was completly up ( eth0 and eth1 was declared down at this time and 
up a few times later : was not the case with later 2.6.21-rc6-mm1 )

Vincent 

