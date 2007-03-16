Return-Path: <linux-kernel-owner+w=401wt.eu-S1753136AbXCPJOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbXCPJOF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 05:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753447AbXCPJOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 05:14:05 -0400
Received: from max.feld.cvut.cz ([147.32.192.36]:35750 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753136AbXCPJOB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 05:14:01 -0400
From: CIJOML <cijoml@volny.cz>
To: Oliver Neukum <oneukum@suse.de>
Subject: Re: kernel OOPSes when changing DVB-T adapter in 2.6.21-rc3
Date: Fri, 16 Mar 2007 10:13:36 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-dvb@linuxtv.org,
       linux-kernel@vger.kernel.org
References: <200703091641.54249.cijoml@volny.cz> <200703151226.42316.cijoml@volny.cz> <200703151502.32161.oneukum@suse.de>
In-Reply-To: <200703151502.32161.oneukum@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703161013.37312.cijoml@volny.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

looks like more general problem with 2.6.21-rc3. This happens when I remove my 
PCMCIA USB2.0/IEEE1384 adapter from slot:

BUG: unable to handle kernel NULL pointer dereference at virtual address 
00000094
 printing eip:
c023e817
*pde = 00000000
Oops: 0000 [#1]
PREEMPT
Modules linked in: bnep rfcomm hidp l2cap lp wlan_tkip fuse eeprom hci_usb 
bluetooth eth1394 usbhid 8250_pci 8250 serial_core wlan_scan_sta 
ath_rate_sample snd_intel8x0 snd_intel8x0m ath_pci nsc_ircc snd_ac97_codec 
wlan irda ide_cd ac97_bus parport_pc 8139too mii ohci1394 ieee1394 ath_hal(P) 
crc_ccitt iTCO_wdt iTCO_vendor_support psmouse pcspkr rtc cdrom ohci_hcd 
snd_pcm snd_timer snd snd_page_alloc parport i2c_i801 uhci_hcd ehci_hcd
CPU:    0
EIP:    0060:[<c023e817>]    Tainted: P       VLI
EFLAGS: 00010246   (2.6.21-rc3 #2)
EIP is at class_device_remove_attrs+0xa/0x30
eax: f7b37b18   ebx: 00000000   ecx: f896f244   edx: 00000000
esi: 00000000   edi: f7b37b18   ebp: 00000000   esp: c1b99e4c
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process pccardd (pid: 788, ti=c1b98000 task=c1b7ea70 task.ti=c1b98000)
Stack: f7b37b18 f7b37b20 00000000 c023e8e1 00000000 f7b37b18 f7b379c4 f895eccf
       00000000 c023e917 f7b37990 f895ecb6 f8964381 66241c89 0000000d 00000303
       fcb2c05f 00000000 00000000 f78f2000 f895ecd7 c023c2ec f78f20a4 f78f20a4
Call Trace:
 [<c023e8e1>] class_device_del+0xa4/0xd2
 [<f895eccf>] __nodemgr_remove_host_dev+0x0/0xb [ieee1394]
 [<c023e917>] class_device_unregister+0x8/0x10
 [<f895ecb6>] nodemgr_remove_ne+0x61/0x7a [ieee1394]
 [<fcb2c05f>] ether1394_mac_addr+0x0/0x12 [eth1394]
 [<f895ecd7>] __nodemgr_remove_host_dev+0x8/0xb [ieee1394]
 [<c023c2ec>] device_for_each_child+0x1a/0x3c
 [<f895eff6>] nodemgr_remove_host+0x30/0x90 [ieee1394]
 [<f895c538>] __unregister_host+0x1a/0xa6 [ieee1394]
 [<c0125dd1>] flush_cpu_workqueue+0x94/0xb1
 [<f895c74f>] highlevel_remove_host+0x21/0x42 [ieee1394]
 [<f895c2c9>] hpsb_remove_host+0x37/0x56 [ieee1394]
 [<f895120c>] ohci1394_pci_remove+0x44/0x1c7 [ohci1394]
 [<c01de144>] pci_device_remove+0x16/0x35
 [<c023e037>] __device_release_driver+0x6e/0x8b
 [<c023e421>] device_release_driver+0x1d/0x32
 [<c023dadb>] bus_remove_device+0x5b/0x69
 [<c023c612>] device_del+0xfa/0x152
 [<c023c672>] device_unregister+0x8/0x10
 [<c01db65c>] pci_stop_dev+0x20/0x4e
 [<c01db745>] pci_remove_bus_device+0x26/0x8c
 [<c01db7c5>] pci_remove_behind_bridge+0x1a/0x2d
 [<c0254d3a>] socket_shutdown+0x6d/0xb3
 [<c0254d9c>] socket_remove+0x1c/0x26
 [<c0255391>] pccardd+0x138/0x1f3
 [<c011602c>] default_wake_function+0x0/0xc
 [<c0255259>] pccardd+0x0/0x1f3
 [<c0128750>] kthread+0xa0/0xc8
 [<c01286b0>] kthread+0x0/0xc8
 [<c0104823>] kernel_thread_helper+0x7/0x10
 =======================
Code: ff c3 85 c0 74 08 83 c0 08 e9 05 fe f4 ff b8 ea ff ff ff c3 85 c0 74 08 
83 c0 08 e9 98 e1 f4 ff c3 57 56 53 89 c7 8b 70 44 31 db <83> be 94 00 00 00 
00 75 09 eb 17 89 f8 e8 d7 ff ff ff 89 da 03
EIP: [<c023e817>] class_device_remove_attrs+0xa/0x30 SS:ESP 0068:c1b99e4c


Dne ètvrtek 15 bøezen 2007 15:02 Oliver Neukum napsal(a):
> Am Donnerstag, 15. März 2007 12:26 schrieb CIJOML:
> > Hi,
> >
> > 2.6.20 is fine
> >
> > Michal
>
> Could you narrow it down a bit? Does rc2 work?
>
> 	Regards
> 		Oliver
