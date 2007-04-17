Return-Path: <linux-kernel-owner+w=401wt.eu-S1030778AbXDQQbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030778AbXDQQbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 12:31:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031163AbXDQQbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 12:31:11 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:46002 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030778AbXDQQbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 12:31:09 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17956.63043.521397.597430@smtp.charter.net>
Date: Tue, 17 Apr 2007 12:30:59 -0400
From: "John Stoffel" <john@stoffel.org>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: John Stoffel <john@stoffel.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: 2.6.21-rc6-mm1 ATA HPT37x regression
In-Reply-To: <4624D4C3.9010109@ru.mvista.com>
References: <17956.12963.163961.762444@smtp.charter.net>
	<4624D4C3.9010109@ru.mvista.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Sergei" == Sergei Shtylyov <sshtylyov@ru.mvista.com> writes:

Sergei> Hello.
Sergei> John Stoffel wrote:

>> I was just testing out 2.6.21-rc6-mm1 to test some Cyclades patches
>> and I noticed that my HPT302 (rev1) controller with a pair of 120gb WD
>> disks are not longer detected and I get the following in the dmesg
>> logs:

>> [  148.121490] hpt37x: DPLL did not stabilize.

>> Where before, under 2.6.21-rc6 I got the following:

Sergei> For the moment I thought you're reporting another hpt366.c
Sergei> driver breakage but then noticed the next line:

I used to think that I wanted to use that driver too, but it's not
going to work.  It's because I've got the version 1 of the chip, not
the newer version 2 or higher version.  

It looks like you really mean for me to use the hpt3x2.c driver
instead, since that's the only other one which mentions the
PCI_DEVICE_ID_TTI_HPT302 device id in it's init method.

>> [  173.749349] pata_hpt37x: BIOS has not set timing clocks.
>> [  173.752949] hpt37x: HPT302: Bus clock 33MHz.

Sergei>    Obviously this was bacause of switching from PCI to DPLL
Sergei>    clock. The old and new drivers are different in how they
Sergei>    handle DPLL calibration though.  Could you try hpt366.c
Sergei>    (there's been report about its failure too recently -- not
Sergei>    enought details yet)?

I don't think it will work here, it won't even touch the card since
the pci_device_id won't match at all.  The htp366.c only looks at
HPT366 ids, while mine is an HPT302 id.  

As a quick note, 2.6.21-rc7 is working just fine here.  

>> [  173.754409] ACPI: PCI Interrupt 0000:03:06.0[A] -> GSI 18 (level,
>> low) -> IRQ
>> 18
>> [  173.758403] ata5: PATA max UDMA/133 cmd 0x0001ecf8 ctl 0x0001ecf2
>> bmdma 0x000
>> 1e800 irq 18
>> [  173.761396] ata6: PATA max UDMA/133 cmd 0x0001ece0 ctl 0x0001ecda
>> bmdma 0x000
>> 1e808 irq 18
>> [  173.764319] scsi6 : pata_hpt37x
>> [  173.928997] ATA: abnormal status 0x78 on port 0x0001ecff
>> [  173.930511] scsi7 : pata_hpt37x
>> [  174.094906] ATA: abnormal status 0x8 on port 0x0001ece7
 
>> Here's my lspci infomation on the board, it's an addon.  My apologies
>> for the crappy word wrapping, xterms inside screen, etc. 

>> 03:06.0 RAID bus controller: Triones Technologies, Inc. HPT302/302N
>> (rev 01)
>> Subsystem: Triones Technologies, Inc. Unknown device 0001
>> Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
>> ParErr- Step
>> ping- SERR+ FastB2B-
>> Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
>> >TAbort- <TAbort
>> - <MAbort- >SERR- <PERR-
>> Latency: 120 (2000ns min, 2000ns max)
>> Interrupt: pin A routed to IRQ 11
>> Region 0: I/O ports at ecf8 [size=8]
>> Region 1: I/O ports at ecf0 [size=4]
>> Region 2: I/O ports at ece0 [size=8]
>> Region 3: I/O ports at ecd8 [size=4]
>> Region 4: I/O ports at e800 [size=256]
>> Expansion ROM at f9000000 [disabled] [size=128K]
>> Capabilities: [60] Power Management version 2
>> Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
>> PME(D0-,D1-,D2-,D3hot
>> -,D3cold-)
>> Status: D0 PME-Enable- DSel=0 DScale=0 PME-

Sergei> Yeah, that's a "plain" HPT302 chip with the default 66 MHz
Sergei> DPLL clock.

Ok, so do I need to do anything special with the next -mm release and
the next version?

Thanks,
John
