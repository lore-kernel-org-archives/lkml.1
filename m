Return-Path: <linux-kernel-owner+w=401wt.eu-S1757021AbZFNRBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021AbZFNRBl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 13:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752436AbZFNRBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 13:01:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37580 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648AbZFNRBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 13:01:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Meyer <thomas@m3y3r.de>
Subject: Re: 2.6.30: suspend-to-ram, second s2r wakes up immediately
Date: Sun, 14 Jun 2009 19:01:46 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>
References: <1244996001.8440.10.camel@localhost> <200906141828.11970.rjw@sisk.pl> <1244997882.8440.13.camel@localhost>
In-Reply-To: <1244997882.8440.13.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906141901.46687.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 June 2009, Thomas Meyer wrote:
> Am Sonntag, den 14.06.2009, 18:28 +0200 schrieb Rafael J. Wysocki:
> > On Sunday 14 June 2009, Thomas Meyer wrote:
> > > Hello.
> > > 
> > > After a cold start of the computer, the first suspend-to-ram works as it
> > > should and everything is fine.
> > > 
> > > But after waking up again, the second suspend-to-ram (in a row) seems to
> > > work, but the computer wakes up immediately (i.e. it doesn't stay in
> > > S3)!
> > > 
> > > Now the strange part: after re-plugging my 4-port usb hub, the computer
> > > (in a third suspend-to-ram try) enters S3 without waking up immediately
> > > again.
> > > 
> > > Strange, hmm?
> > 
> > So, it looks like there's a device that generates a wake-up request after the
> > second suspend automatically.
> > 
> > Can you send the output of lspci from the box?
> > 
> 
> sure:
> 
> 00:00.0 RAM memory: nVidia Corporation MCP55 Memory Controller (rev a1)
> 	Subsystem: Micro-Star International Co., Ltd. Device 7250
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
> 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Capabilities: [44] HyperTransport: Slave or Primary Interface
> 		Command: BaseUnitID=0 UnitCnt=15 MastHost- DefDir- DUL-
> 		Link Control 0: CFlE+ CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- LSEn+ ExtCTL- 64b-
> 		Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
> 		Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
> 		Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit DwFcInEn- LWO=8bit DwFcOutEn-
> 		Revision ID: 1.03
> 		Link Frequency 0: 1.0GHz
> 		Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
> 		Link Frequency Capability 0: 200MHz+ 300MHz+ 400MHz+ 500MHz+ 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
> 		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
> 		Link Frequency 1: 200MHz
> 		Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
> 		Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 600MHz- 800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
> 		Error Handling: PFlE+ OFlE+ PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF- RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
> 		Prefetchable memory behind bridge Upper: 00-00
> 		Bus Number: 00
> 	Capabilities: [dc] HyperTransport: MSI Mapping Enable+ Fixed-
> 		Mapping Address Base: 00000000fee00000
> 
> 00:01.0 ISA bridge: nVidia Corporation MCP55 LPC Bridge (rev a2)
> 	Subsystem: Micro-Star International Co., Ltd. Device 7250
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Region 0: I/O ports at 2f00 [size=128]
> 
> 00:01.1 SMBus: nVidia Corporation MCP55 SMBus (rev a2)
> 	Subsystem: Micro-Star International Co., Ltd. Device 7250
> 	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Interrupt: pin A routed to IRQ 11
> 	Region 0: I/O ports at 2900 [size=64]
> 	Region 4: I/O ports at 2d00 [size=64]
> 	Region 5: I/O ports at 2e00 [size=64]
> 	Capabilities: [44] Power Management version 2
> 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 	Kernel driver in use: nForce2_smbus
> 
> 00:02.0 USB Controller: nVidia Corporation MCP55 USB Controller (rev a1) (prog-if 10 [OHCI])
> 	Subsystem: Micro-Star International Co., Ltd. Device 7250
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0 (750ns min, 250ns max)
> 	Interrupt: pin A routed to IRQ 22
> 	Region 0: Memory at fe9fb000 (32-bit, non-prefetchable) [size=4K]
> 	Capabilities: [44] Power Management version 2
> 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 	Kernel driver in use: ohci_hcd
> 
> 00:02.1 USB Controller: nVidia Corporation MCP55 USB Controller (rev a2) (prog-if 20 [EHCI])
> 	Subsystem: Micro-Star International Co., Ltd. Device 7250
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0 (750ns min, 250ns max)
> 	Interrupt: pin B routed to IRQ 23
> 	Region 0: Memory at fe9fac00 (32-bit, non-prefetchable) [size=256]
> 	Capabilities: [44] Debug port: BAR=1 offset=0098
> 	Capabilities: [80] Power Management version 2
> 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME+
> 	Kernel driver in use: ehci_hcd

PME+ means that the USB EHCI controller will signal a PME as soon as it is
enabled, so if PME is enabled on the controller before suspend, it will wake up
the system.

Please send a boot log.

Best,
Rafael
