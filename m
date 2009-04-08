Return-Path: <linux-kernel-owner+w=401wt.eu-S1761621AbZDHFas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761621AbZDHFas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 01:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754546AbZDHFaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 01:30:39 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:57423 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbZDHFaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 01:30:39 -0400
Message-ID: <49DC367A.90603@gawab.com>
Date: Tue, 07 Apr 2009 22:30:34 -0700
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: 2.6.30-rc1: invalid opcode with call trace
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Testing 2.6.30-rc1,
While booting I get the following call trace about an invalid opcode.

ACPI: SSDT 3f6d4134 00244 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
ACPI: SSDT 3f6d3ee9 001C6 (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
processor ACPI_CPU:00: registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT 3f6d4378 000C4 (v01  PmRef  Cpu1Ist 00003000 INTL 20050624)
ACPI: SSDT 3f6d40af 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20050624)
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
processor ACPI_CPU:01: registered as cooling_device1
ACPI: Processor [CPU1] (supports 8 throttling states)
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
ACPI: Lid Switch [LID]
input: Power Button (CM) as 
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
ACPI: Power Button (CM) [PBTN]
ACPI: AC Adapter [AC] (on-line)
input: Sleep Button (CM) as 
/devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input3
ACPI: Sleep Button (CM) [SBTN]
ACPI: Battery Slot [BAT0] (battery present)
invalid opcode: 0000 [#1] PREEMPT SMP
last sysfs file: /sys/devices/virtual/vtconsole/vtcon0/uevent
Modules linked in: snd_pcm battery ac button processor intel_agp 
snd_page_alloc reiserfs crc32 sr_mod cdrom sg firewire_ohci 
firewire_core crc_itu_t ata_piix ehci_hcd uhci_hcd usbcore thermal fan

Pid: 1760, comm: async/0 Not tainted (2.6.30-rc1-git #1) 
MM061                           
EIP: 0060:[<f80fb02c>] EFLAGS: 00010286 CPU: 1
EIP is at 0xf80fb02c
EAX: 00000000 EBX: 00000216 ECX: 00000000 EDX: 00000000
ESI: f68fb320 EDI: 00000001 EBP: f7117f88 ESP: f7117f88
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process async/0 (pid: 1760, ti=f7117000 task=f6935390 task.ti=f7117000)
Stack:
 f7117fd0 c015e612 f7117fa8 c0129cf9 f7073bb0 00000000 f693560c f6935390
 00000286 f7117fd0 00000000 f6935390 c012fb20 f704efbc c04f22dc 00000000
 c015e540 00000000 f7117fe0 c015558c c0155550 00000000 00000000 c0103f5f
Call Trace:
 [<c015e612>] ? async_thread+0xd2/0x240
 [<c0129cf9>] ? schedule_tail+0xd9/0x110
 [<c012fb20>] ? default_wake_function+0x0/0x10
 [<c015e540>] ? async_thread+0x0/0x240
 [<c015558c>] ? kthread+0x3c/0x70
 [<c0155550>] ? kthread+0x0/0x70
 [<c0103f5f>] ? kernel_thread_helper+0x7/0x18
Code: 00 00 89 5d f4 8d 9e 88 00 00 00 89 7d fc 89 4d e8 e8 fc ff ff ff 
8b be 98 00 00 00 39 df 74 57 89 f8 e8 fc ff ff ff 89 d8 e8 fc <ff> ff 
ff 8b 4d e8 89 f2 8b 45 ec c7 04 24 01 00 00 00 e8 3d c9
EIP: [<f80fb02c>] 0xf80fb02c SS:ESP 0068:f7117f88
---[ end trace fefef3dd1f6b4bcf ]---
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman

Justin Madru


