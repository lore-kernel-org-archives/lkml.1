Return-Path: <linux-kernel-owner+w=401wt.eu-S1755430AbZERAIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbZERAIc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 20:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbZERAIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 20:08:21 -0400
Received: from gate.crashing.org ([63.228.1.57]:36342 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbZERAIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 20:08:20 -0400
Subject: Oops in usb-serial with keyspan adapter on current upstream
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain
Date: Mon, 18 May 2009 10:07:34 +1000
Message-Id: <1242605255.18075.13.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks !

Current kernels give the oops below at boot with my Keyspan plugged,
used to work fine on 2.6.28 at least.

It looks to me like some kind of race between the disconnection after
the FW load and the re-connect but I'm not sure.

Cheers,
Ben.

usbcore: registered new interface driver usbserial
USB Serial support registered for generic
usbcore: registered new interface driver usbserial_generic
usbserial: USB Serial Driver core
USB Serial support registered for Keyspan - (without firmware)
USB Serial support registered for Keyspan 1 port adapter
USB Serial support registered for Keyspan 2 port adapter
USB Serial support registered for Keyspan 4 port adapter
keyspan 2-1:1.0: Keyspan - (without firmware) converter detected
usb 2-1: firmware: using built-in firmware keyspan/usa49w.fw
usb 2-1: USB disconnect, address 2
usbcore: registered new interface driver keyspan
keyspan: v1.1.5:Keyspan USB to Serial Converter Driver
Unable to handle kernel paging request for data at address 0x00000010
Faulting instruction address: 0xc0000000002da15c
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=4 PowerMac
Modules linked in: snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device snd keyspan uninorth_agp usbserial agpgart soundcore
NIP: c0000000002da15c LR: c0000000002d3760 CTR: c0000000002d35ec
REGS: c00000017a4cb4c0 TRAP: 0300   Not tainted  (2.6.30-rc6-00037-g8646010-dirty)
MSR: 9000000000009032 <EE,ME,IR,DR>  CR: 24000024  XER: 200fffff
DAR: 0000000000000010, DSISR: 0000000040000000
TASK = c00000017a4890e0[191] 'khubd' THREAD: c00000017a4c8000 CPU: 2
GPR00: c000000000755f30 c00000017a4cb740 c000000000783d48 0000000000000001 
GPR04: 0000000000000000 c0000001783fba90 0000000000000001 0000000000000000 
GPR08: 0000000000000000 0000000000000000 0000000000000000 c0000000002d35ec 
GPR12: 0000000024000082 c0000000007b5680 0000000000000002 c0000001781c0a30 
GPR16: 00000000000003e8 0000000000000000 c0000001781fd000 c0000001781c0a30 
GPR20: 0000000000000000 0000000000000000 c0000001781fd800 0000000000000001 
GPR24: c00000017a41a600 c0000001789ab480 c0000001783fb998 0000000000000000 
GPR28: 0000000000000000 c00000017a4cb7b0 c00000000070f8d0 0000000000000000 
NIP [c0000000002da15c] .release_nodes+0x54/0x254
LR [c0000000002d3760] .device_del+0x174/0x1e8
Call Trace:
[c00000017a4cb740] [c00000017a4cb880] 0xc00000017a4cb880 (unreliable)
[c00000017a4cb7f0] [c0000000002d3760] .device_del+0x174/0x1e8
[c00000017a4cb880] [d0000000000b14dc] .usb_serial_disconnect+0xf8/0x1d0 [usbserial]
[c00000017a4cb930] [c0000000003a9280] .usb_unbind_interface+0x7c/0x138
[c00000017a4cb9d0] [c0000000002d6acc] .__device_release_driver+0xb8/0x100
[c00000017a4cba60] [c0000000002d6c80] .device_release_driver+0x30/0x54
[c00000017a4cbaf0] [c0000000002d5d18] .bus_remove_device+0xe4/0x124
[c00000017a4cbb80] [c0000000002d3754] .device_del+0x168/0x1e8
[c00000017a4cbc10] [c0000000003a643c] .usb_disable_device+0xa4/0x15c
[c00000017a4cbcb0] [c0000000003a0a5c] .usb_disconnect+0xc4/0x180
[c00000017a4cbd60] [c0000000003a1b44] .hub_thread+0x594/0x101c
[c00000017a4cbf00] [c000000000065b98] .kthread+0x80/0xcc
[c00000017a4cbf90] [c00000000001fef0] .kernel_thread+0x54/0x70
Instruction dump:
ebc2a308 7c7a1b78 7c872378 39000000 3b800000 3be00000 38010070 f8010070 
f8010078 7c1d0378 48000070 e81e8000 <e96a0010> e8840000 7fab0000 419e0014 
---[ end trace 3ce00127d362ccb2 ]---


