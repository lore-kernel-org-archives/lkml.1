Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab0APSVX (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 13:21:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353Ab0APSVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 13:21:22 -0500
Received: from mail.tmr.com ([64.65.253.246]:34602 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753255Ab0APSVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 13:21:21 -0500
Message-ID: <4B52038F.8010703@tmr.com>
Date: Sat, 16 Jan 2010 13:21:03 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090507 Fedora/1.1.16-1.fc9 NOT Firefox/3.0.11 pango-text SeaMonkey/1.1.16
MIME-Version: 1.0
To: Neil Schemenauer <nas@arctrix.com>
CC: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>
Subject: Re: ATA error with Asus A7VX board
References: <20100114232037.GA17411@arctrix.com>
In-Reply-To: <20100114232037.GA17411@arctrix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Schemenauer wrote:
> Hi,
> 
> I have what seems to be a poorly designed board (based on the number
> of problems that a Google search turns up). However, since I guess
> there are still people that have it and I have some capability to do
> some debugging I thought I should try to fix it rather than throwing
> it out.
> 
> It is possible that my problem is caused by a bad cable, bad memory,
> or a bad drive, but I suspect the board is just temperamental
> (specifically, the way interrupts are handled). The drive had a lot
> of bad sectors a while ago but writing over them seemed to have
> fixed it. The drive was working without errors with another board
> for a while now.
> 
I would reseat the cables (replace if you can), after that either the drive or 
the power supply are suspects. since changing P/S is a PITA for test, if you 
have some monster video card you might pull it and put in something low power.

Sure, it could be the board, but other things are more likely.

> I've tried booting with and without the "noapic" command line option
> and with the old ide driver and the pata_via driver. Each
> configuration seems to have its own problems. Certain configurations
> generated errors like "IRQ nobody cared" and "spurious interrupt".
> The noapic and ide driver combination results in the following error:
> 
> [  366.463909] spurious 8259A interrupt: IRQ7.
> [ 5432.078546] hda: task_no_data_intr: status=0x30 { DeviceFault SeekComplete }
> [ 5432.078555] hda: possibly failed opcode: 0xb0
> [ 5462.224012] hda: lost interrupt
> 
> The "noapic" and pata_via is what I'm running now. It works for a
> while and then I get an error like the following:
> 
> ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> ata4.00: BMDMA stat 0x65
> ata4.00: failed command: READ DMA
> ata4.00: cmd c8/00:18:4f:27:1b/00:00:00:00:00/e0 tag 0 dma 12288 in
>          res 51/10:18:4f:27:1b/00:00:00:00:00/a0 Emask 0x81 (invalid argument)
> ata4.00: status: { DRDY ERR }
> ata4.00: error: { IDNF }
> ata4.00: configured for UDMA/100
> ata4.01: configured for UDMA/100
> sd 3:0:0:0: [sda] Result: hostbyte=0x00 driverbyte=0x08
> sd 3:0:0:0: [sda] Sense Key : 0xb [current] [descriptor]
> Descriptor sense data with sense descriptors (in hex):
>         72 0b 14 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
>         00 1b 27 4f 
> sd 3:0:0:0: [sda] ASC=0x14 ASCQ=0x0
> sd 3:0:0:0: [sda] CDB: cdb[0]=0x28: 28 00 00 1b 27 4f 00 00 18 00
> end_request: I/O error, dev sda, sector 1779535
> ata4: EH complete
> 
> I'm attaching the kernel log for the pata_via and ide setups and the
> output from lspci.
> 
> Best regards,
> 
>   Neil
> 


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
