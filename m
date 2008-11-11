Return-Path: <linux-kernel-owner+w=401wt.eu-S1756872AbYKKOcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872AbYKKOcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 09:32:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756907AbYKKOba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 09:31:30 -0500
Received: from rtr.ca ([76.10.145.34]:35427 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756898AbYKKOb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 09:31:29 -0500
Message-ID: <4919976E.6020205@rtr.ca>
Date: Tue, 11 Nov 2008 09:32:14 -0500
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
Cc: Tim Connors <tconnors@rather.puzzling.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: sata error on ICH8M
References: <alpine.DEB.2.00.0811040833110.24370@dirac.rather.puzzling.org> <49199029.8070802@kernel.org>
In-Reply-To: <49199029.8070802@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello,
> 
> Tim Connors wrote:
>> I'm running a debian 2.6.26-9 kernel (sid) on a new laptop with:
> 
> Hmmm...
> 
>> 00:1f.2 SATA controller: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) SATA AHCI Controller (rev 03) (prog-if 01 [AHCI 1.0])
>>         Subsystem: Dell Device 0275
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
>>         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 0
>>         Interrupt: pin B routed to IRQ 378
>>         Region 0: I/O ports at 1c00 [size=8]
>>         Region 1: I/O ports at 18d4 [size=4]
>>         Region 2: I/O ports at 18d8 [size=8]
>>         Region 3: I/O ports at 18d0 [size=4]
>>         Region 4: I/O ports at 18e0 [size=32]
>>         Region 5: Memory at f8504000 (32-bit, non-prefetchable) [size=2K]
>>         Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/2 Enable+
>>                 Address: fee0300c  Data: 41a1
>>         Capabilities: [70] Power Management version 3
>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
>>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>         Capabilities: [a8] SATA HBA <?>
>>         Kernel driver in use: ahci
>>         Kernel modules: ahci
>>
>> Soon after booting, and possibly after the disk had spun down and was
>> asked to spin back up (which it had done successfully a few times so
>> far, with a spinddown timeout of 10 minutes, and using laptop_mode), it
>> had a sata error:
>>
>> Nov  4 01:49:29 gamow kernel: [ 1865.106289] ata1.00: exception Emask 0x10 SAct 0x3ff SErr 0x50000 action 0xe frozen
>> Nov  4 01:50:29 gamow kernel: [ 1865.106307] ata1: SError: { PHYRdyChg CommWake }
>> Nov  4 01:50:29 gamow kernel: [ 1865.106319] ata1.00: cmd 61/08:00:bd:c9:57/00:00:00:00:00/40 tag 0 ncq 4096 out
>> Nov  4 01:50:29 gamow kernel: [ 1865.106322]          res 40/00:00:02:4f:c2/00:00:00:00:00/00 Emask 0x14 (ATA bus error)
>> Nov  4 01:50:29 gamow kernel: [ 1865.106329] ata1.00: status: { DRDY }
>> Nov  4 01:50:29 gamow kernel: [ 1865.106339] ata1.00: cmd 61/08:08:35:7a:73/00:00:00:00:00/40 tag 1 ncq 4096 out
>> Nov  4 01:50:29 gamow kernel: [ 1865.106343]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x14 (ATA bus error)
>> Nov  4 01:50:29 gamow kernel: [ 1865.106350] ata1.00: status: { DRDY }
>> Nov  4 01:50:29 gamow kernel: [ 1865.106361] ata1.00: cmd 61/08:10:35:36:9b/00:00:00:00:00/40 tag 2 ncq 4096 out
>> Nov  4 01:50:29 gamow kernel: [ 1865.106364]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x14 (ATA bus error)
>> Nov  4 01:50:29 gamow kernel: [ 1865.106371] ata1.00: status: { DRDY }
>> Nov  4 01:50:29 gamow kernel: [ 1865.106382] ata1.00: cmd 61/28:18:55:94:e2/00:00:00:00:00/40 tag 3 ncq 20480 out
>>
>> And then it fails to reset after some time, remounting the devices
>> readonly (although what wasn't already in the cache became unreadable with
>> lots of IO errors rapidly filling up dmesg).  None of the logs made it to
>> disk, naturally enough, and this was what I caught in syslog before syslog
>> bailed.  There were interesting messages that happened after this, but the
>> dmesg buffer filled up before I thought about saving them.
> 
> Well, the disk is already a goner at that point so you need to either
> set up a netconsole or plug in a usb stick, mount it and do "while
> true; do dmesg -c >> /mnt/usbstick/dmesg.out; sleep 1; done" to
> capture the kernel log.
> 
>> My /sys/class/scsi_host/host0/link_power_management_policy is:
>> min_power
>> .  powertop had earlier (in a previous warm-boot) prompted me
>> to set link_power_management_policy, so I had been tweaking that, but I
>> didn't look at its default setting - I presume it was already at
>> min_power, as it is now from a fresh (cold) bootup.
>>
>> Just in case it is related, in each bootup, I earlier get
>> Nov  4 01:20:26 gamow kernel: [  116.217492] CE: hpet increasing min_delta_ns to 15000 nsec
>> Nov  4 01:20:28 gamow kernel: [  118.073078] CE: hpet increasing min_delta_ns to 22500 nsec
>> Nov  4 01:20:30 gamow kernel: [  120.467250] ACPI: EC: missing confirmations, switch off interrupt mode.
>> Nov  4 01:20:30 gamow kernel: [  120.603593] CE: hpet increasing min_delta_ns to 33750 nsec
>> Nov  4 01:20:31 gamow kernel: [  121.004372] ACPI Exception (evregion-0420): AE_TIME, Returned by Handler for [EmbeddedControl] [20080321]
>> Nov  4 01:20:31 gamow kernel: [  121.004372] ACPI Error (psparse-0530): Method parse/execution failed [\_SB_.PCI0.LPCB.BAT1._BST] (Node ffff81013fa6cb90), AE_TIME
>> Nov  4 01:20:31 gamow kernel: [  121.004372] ACPI Exception (battery-0360): AE_TIME, Evaluating _BST [20080321]
>>
>> and/or
>>
>> [ 1587.842640] CE: hpet increasing min_delta_ns to 15000 nsec
>> (successively increasing as time goes on)
>>
>> The sata link went belly up perhaps a few minutes after I went to bed
>> lastnight, and the only thing I can think of that I did before then was to
>> unplug and replug the ethernet and/or the wireless.  The ACPI messages
>> seem to happen around networking events on this laptop, but I haven't had
>> a chance to investigate further.
> 
> I really need to see how the recovery attempt failed.  Can you please
> reproduce the problem and report the kernel log?  Also, please report
> how reproducible the problem is.
...


I wonder if this is another scenario, where a full reset of the AHCI host
would recover the system, similar to the one I emailed you about last month.. ?



