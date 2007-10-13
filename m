Return-Path: <linux-kernel-owner+w=401wt.eu-S1760005AbXJMQNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760005AbXJMQNT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 12:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753402AbXJMQNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 12:13:05 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:55722 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbXJMQND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 12:13:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gkVWE728NnWrkpPlPYbWl30PHK4Mg02sch8RPHh65Lfdzl+xEaggbLXimejyNKb0Cd85OvpKe6pXX5s9WeI7HeJXiglCOKieQvsv5qKbBwT5IFLb04xo5zX49h+TLeI220asqkSvqZAUzVv8EYEozhFu4Z/L4e0PyBB/sUeladw=
Message-ID: <68676e00710130913g5892e026i32c148b426dbb2cc@mail.gmail.com>
Date: Sat, 13 Oct 2007 18:13:01 +0200
From: Luca <kronos.it@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: Hitachi disk: spurious completions during NCQ
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20071012174637.9b3b517b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071010190342.GA13843@dreamland.darkstar.lan>
	 <20071012174637.9b3b517b.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 10 Oct 2007 21:03:43 +0200
> Luca Tettamanti <kronos.it@gmail.com> wrote:
>
> > Hello,
> > sometimes kernel complains about spurious completions on my new
> > notebook:
> >
> > ata3.00: exception Emask 0x2 SAct 0x407fd SErr 0x0 action 0x2 frozen
> > ata3.00: spurious completions during NCQ issue=0x0 SAct=0x407fd FIS=005040a1:00020000
> > ata3.00: cmd 61/08:00:c7:5a:82/00:00:1b:00:00/40 tag 0 cdb 0x0 data 4096 out
> >          res 50/00:10:07:5b:82/00:00:1b:00:00/40 Emask 0x2 (HSM violation)
> > ata3.00: cmd 61/08:10:3f:5b:fa/00:00:18:00:00/40 tag 2 cdb 0x0 data 4096 out
> >          res 50/00:10:07:5b:82/00:00:1b:00:00/40 Emask 0x2 (HSM violation)
> > ata3.00: cmd 61/08:18:5f:5b:fa/00:00:18:00:00/40 tag 3 cdb 0x0 data 4096 out
> >          res 50/00:10:07:5b:82/00:00:1b:00:00/40 Emask 0x2 (HSM violation)
> > ata3.00: cmd 61/18:20:6f:5b:fa/00:00:18:00:00/40 tag 4 cdb 0x0 data 12288 out
> >          res 50/00:10:07:5b:82/00:00:1b:00:00/40 Emask 0x2 (HSM violation)
> > ata3.00: cmd 61/08:28:e7:19:fd/00:00:18:00:00/40 tag 5 cdb 0x0 data 4096 out
> >          res 50/00:10:07:5b:82/00:00:1b:00:00/40 Emask 0x2 (HSM violation)
> > ata3.00: cmd 61/08:30:df:59:ae/00:00:1a:00:00/40 tag 6 cdb 0x0 data 4096 out
> >          res 50/00:10:07:5b:82/00:00:1b:00:00/40 Emask 0x2 (HSM violation)
> > ata3.00: cmd 61/08:38:3f:5a:ae/00:00:1a:00:00/40 tag 7 cdb 0x0 data 4096 out
> >          res 50/00:10:07:5b:82/00:00:1b:00:00/40 Emask 0x2 (HSM violation)
> > ata3.00: cmd 61/08:40:6f:62:ae/00:00:1a:00:00/40 tag 8 cdb 0x0 data 4096 out
> >          res 50/00:10:07:5b:82/00:00:1b:00:00/40 Emask 0x2 (HSM violation)
> > ata3.00: cmd 61/28:48:d7:59:7e/00:00:1b:00:00/40 tag 9 cdb 0x0 data 20480 out
> >          res 50/00:10:07:5b:82/00:00:1b:00:00/40 Emask 0x2 (HSM violation)
> > ata3.00: cmd 61/10:50:07:5b:82/00:00:1b:00:00/40 tag 10 cdb 0x0 data 8192 out
> >          res 50/00:10:07:5b:82/00:00:1b:00:00/40 Emask 0x2 (HSM violation)
> > ata3.00: cmd 61/30:90:f7:5a:fa/00:00:18:00:00/40 tag 18 cdb 0x0 data 24576 out
> >          res 50/00:10:07:5b:82/00:00:1b:00:00/40 Emask 0x2 (HSM violation)
> > ata3: soft resetting port
> > ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> > ata3.00: configured for UDMA/133
> > ata3: EH complete
> > sd 2:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
> > sd 2:0:0:0: [sda] Write Protect is off
> > sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
> > sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> >
> > (this is a very recent 2.6.23-git, SMP, x86_64)
>
> The latest kernel, a serious-looking problem, sent to the correct mailing
> lists.  After two days nobody has bothered replying.
>
> > The disk is:
> >
> > ATA device, with non-removable media
> >         Model Number:       Hitachi HTS542525K9SA00
> >         Firmware Revision:  BBFOC31P
> >
> > The controller is:
> >
> > 00:1f.2 SATA controller: Intel Corporation Mobile SATA AHCI Controller (rev 03) (prog-if 01 [AHCI 1.0])
> >         Subsystem: ASUSTeK Computer Inc. Unknown device 14e7
> >         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> >         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> >         Latency: 0
> >         Interrupt: pin B routed to IRQ 1272
> >         Region 0: I/O ports at ec00 [size=8]
> >         Region 1: I/O ports at e880 [size=4]
> >         Region 2: I/O ports at e800 [size=8]
> >         Region 3: I/O ports at e480 [size=4]
> >         Region 4: I/O ports at e400 [size=32]
> >         Region 5: Memory at febff800 (32-bit, non-prefetchable) [size=2K]
> >         Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/2 Enable+
> >                 Address: fee0300c  Data: 41b9
> >         Capabilities: [70] Power Management version 3
> >                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
> >                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> >         Capabilities: [a8] #12 [0010]
> >
> > and I'm using AHCI driver.
> >
> > I see that similar disks are already blacklisted, probably this one is
> > bugged too - though the error is pretty rare :(
> >
>
> Does this cause any other symptoms?  ie: does the system otherwise work OK?

The system is stable, the EH seems to be doing its job.

Luca
