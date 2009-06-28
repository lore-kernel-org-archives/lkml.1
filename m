Return-Path: <linux-kernel-owner+w=401wt.eu-S1753135AbZF1TuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbZF1TuI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 15:50:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbZF1Tt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 15:49:57 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:41337 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbZF1Tt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 15:49:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=if19teteFiP15GvDNL6f91KFerq8hZXZBwpInVYj3hr0gCEbcYpPZoxZ+qouY61f2q
         Y3lOGbWkB4xF8SwQCW6p7Z86nc8ZGJOWgcxnYFXseSzDJTvoAD/K6yPXtJTDv2FihvdP
         fsy0DRY2PF2j69IhISuIcNQ8eAQmg2f1ZC7KI=
MIME-Version: 1.0
Date: Sun, 28 Jun 2009 21:49:59 +0200
Message-ID: <9c30dffe0906281249md437f08he4d4b065d345803e@mail.gmail.com>
Subject: [2.6.31-rc1] oops in __ieee80211_stop_queue
From: Bjarke Istrup Pedersen <gurligebis@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops happens when pcmcia p54 card is inserted.
Works with 2.6.30, broken in 2.6.31-rc1.

Output of relevant dmesg part:

pcmcia_socket pcmcia_socket1: pccard: CardBus card inserted into slot 1
pci 0000:04:00.0: reg 10 32bit mmio: [0x000000-0x001fff]
pci 0000:04:00.0: supports D1 D2
pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:04:00.0: PME# disabled
yenta_cardbus 0000:02:04.1: EnE: chaning testregister 0xC9, 04 -> 04
p54pci 0000:04:00.0: enabling device (0000 -> 0002)
p54pci 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
p54pci 0000:04:00.0: setting latency timer to 64
p54pci 0000:04:00.0: firmware: using built-in firmware isl3886pci
phy2: p54 detected a LM86 firmware
p54: rx_mtu reduced from 3240 to 2376
phy2: FW rev 2.13.12.0 - Softmac protocol 5.9
phy2: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
BUG: unable to handle kernel NULL pointer dereference at 00000280
IP: [<c1288e61>] __ieee80211_stop_queue+0x2b/0x43
*pde = 00000000
Oops: 0000 [#1] SMP
last sysfs file:
/sys/devices/pci0000:00/0000:00:14.4/0000:02:04.1/0000:04:00.0/class

Pid: 535, comm: pccardd Not tainted (2.6.31-rc1 #2) TravelMate 540
EIP: 0060:[<c1288e61>] EFLAGS: 00010046 CPU: 0
EIP is at __ieee80211_stop_queue+0x2b/0x43
EAX: dedd41a0 EBX: 00000000 ECX: 00000000 EDX: 00000000
ESI: 00000000 EDI: dedd4204 EBP: 00000000 ESP: df8abdcc
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process pccardd (pid: 535, ti=df8aa000 task=df9c7000 task.ti=df8aa000)
Stack:
 dedd41a0 00000000 c1288ea0 00000286 dedd4920 ded2a300 00003ff0 00000470
<0> c11a83b1 00020200 00020200 dedd41a0 dedd4940 00000286 00004460 dedd4934
<0> dedd4934 c11f6f64 dfa5a020 ded2a300 dedd4920 00000408 000003fc c11a84ae
Call Trace:
 [<c1288ea0>] ? ieee80211_stop_queues_by_reason+0x27/0x3f
 [<c11a83b1>] ? p54_assign_address+0x16b/0x1cd
 [<c11f6f64>] ? __alloc_skb+0x48/0x105
 [<c11a84ae>] ? p54_alloc_skb+0x9b/0xb3
 [<c11aaefd>] ? p54_read_eeprom+0x3b/0x1b6
 [<c11ab652>] ? p54p_open+0x2e1/0x3c0
 [<c12941b6>] ? p54p_probe+0x2eb/0x362
 [<c113430b>] ? local_pci_probe+0xb/0xc
 [<c1134485>] ? pci_device_probe+0x41/0x63
 [<c117cde1>] ? driver_probe_device+0x76/0xe6
 [<c117c4db>] ? bus_for_each_drv+0x37/0x5f
 [<c117cf33>] ? device_attach+0x44/0x54
 [<c117ceac>] ? __device_attach+0x0/0x28
 [<c117c397>] ? bus_attach_device+0x1b/0x46
 [<c117b5ac>] ? device_add+0x2ee/0x428
 [<c11f04b0>] ? pci_write+0x1c/0x21
 [<c11308ae>] ? pci_bus_add_device+0xc/0x2c
 [<c11308ec>] ? pci_bus_add_devices+0x1e/0xd2
 [<c1290599>] ? cb_alloc+0x97/0xa9
 [<c11ac12c>] ? socket_insert+0x8a/0xb0
 [<c11ac877>] ? pccardd+0x158/0x1d6
 [<c11ac71f>] ? pccardd+0x0/0x1d6
 [<c103130a>] ? kthread+0x66/0x6b
 [<c10312a4>] ? kthread+0x0/0x6b
 [<c10031ff>] ? kernel_thread_helper+0x7/0x10
Code: 56 53 0f b7 58 48 39 da 7c 11 ba 38 01 00 00 b8 69 72 37 c1 5b
5e e9 97 9d d9 ff 83 7c 90 54 00 75 17 8b 70 68 0f b7 da c1 e3 08 <03>
9e 80 02 00 00 8d 73 08 3e 80 4b 08 01 8d 44 90 54 0f ab 08
EIP: [<c1288e61>] __ieee80211_stop_queue+0x2b/0x43 SS:ESP 0068:df8abdcc
CR2: 0000000000000280
---[ end trace 1227e32b55188f72 ]---
