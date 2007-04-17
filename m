Return-Path: <linux-kernel-owner+w=401wt.eu-S964934AbXDQOHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964934AbXDQOHM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 10:07:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964959AbXDQOHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 10:07:12 -0400
Received: from rtsoft2.corbina.net ([85.21.88.2]:60000 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with SMTP id S964934AbXDQOHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 10:07:10 -0400
Message-ID: <4624D4C3.9010109@ru.mvista.com>
Date: Tue, 17 Apr 2007 18:08:03 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: John Stoffel <john@stoffel.org>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: 2.6.21-rc6-mm1 ATA HPT37x regression
References: <17956.12963.163961.762444@smtp.charter.net>
In-Reply-To: <17956.12963.163961.762444@smtp.charter.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

John Stoffel wrote:

> I was just testing out 2.6.21-rc6-mm1 to test some Cyclades patches
> and I noticed that my HPT302 (rev1) controller with a pair of 120gb WD
> disks are not longer detected and I get the following in the dmesg
> logs:

>     [  148.121490] hpt37x: DPLL did not stabilize.

> Where before, under 2.6.21-rc6 I got the following:

   For the moment I thought you're reporting another hpt366.c driver breakage but then noticed the next line:

>     [  173.749349] pata_hpt37x: BIOS has not set timing clocks.
>     [  173.752949] hpt37x: HPT302: Bus clock 33MHz.

   Obviously this was bacause of switching from PCI to DPLL clock. The old and new drivers are different in how they handle DPLL calibration though.  Could you try hpt366.c (there's been report about its failure too recently -- not enought details yet)?

>     [  173.754409] ACPI: PCI Interrupt 0000:03:06.0[A] -> GSI 18 (level,
>     low) -> IRQ
>      18
>     [  173.758403] ata5: PATA max UDMA/133 cmd 0x0001ecf8 ctl 0x0001ecf2
>     bmdma 0x000
>     1e800 irq 18
>     [  173.761396] ata6: PATA max UDMA/133 cmd 0x0001ece0 ctl 0x0001ecda
>     bmdma 0x000
>     1e808 irq 18
>     [  173.764319] scsi6 : pata_hpt37x
>     [  173.928997] ATA: abnormal status 0x78 on port 0x0001ecff
>     [  173.930511] scsi7 : pata_hpt37x
>     [  174.094906] ATA: abnormal status 0x8 on port 0x0001ece7
 
> Here's my lspci infomation on the board, it's an addon.  My apologies
> for the crappy word wrapping, xterms inside screen, etc. 

>   03:06.0 RAID bus controller: Triones Technologies, Inc. HPT302/302N
>   (rev 01)
> 	  Subsystem: Triones Technologies, Inc. Unknown device 0001
> 	  Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
>   ParErr- Step
>   ping- SERR+ FastB2B-
> 	  Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
>   >TAbort- <TAbort
>   - <MAbort- >SERR- <PERR-
> 	  Latency: 120 (2000ns min, 2000ns max)
> 	  Interrupt: pin A routed to IRQ 11
> 	  Region 0: I/O ports at ecf8 [size=8]
> 	  Region 1: I/O ports at ecf0 [size=4]
> 	  Region 2: I/O ports at ece0 [size=8]
> 	  Region 3: I/O ports at ecd8 [size=4]
> 	  Region 4: I/O ports at e800 [size=256]
> 	  Expansion ROM at f9000000 [disabled] [size=128K]
> 	  Capabilities: [60] Power Management version 2
> 		  Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
>   PME(D0-,D1-,D2-,D3hot
>   -,D3cold-)
> 		  Status: D0 PME-Enable- DSel=0 DScale=0 PME-

   Yeah, that's a "plain" HPT302 chip with the default 66 MHz DPLL clock.

MBR, Sergei
