Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbYAAUV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbYAAUV1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 15:21:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754582AbYAAUVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 15:21:19 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:57548 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154AbYAAUVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 15:21:18 -0500
Date: Tue, 1 Jan 2008 22:21:16 +0200 (EET)
From: Timo Jantunen <jeti@iki.fi>
To: LKML <linux-kernel@vger.kernel.org>, alsa-devel@alsa-project.org
Subject: ALSA HDA problem with 64-bit kernels
Message-ID: <Pine.LNX.4.64.0801012144180.5646@limbo>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heip!


I recently moved to 64-bit kernel, but mixed sounds (ie. mpegs played with 
a media player) don't work with optical S/PDIF connection. AC3/DTS 
passthrough still works, and I can hear the mixed sounds on analog 
connector. And yes, I have unmuted the IEC958 mixer setting.

Tested kernels:

ALSA 1.0.14:
2.6.23.1 32bit: works
2.6.23.1 64bit: broken
2.6.23.12 64bit: broken
2.6.23.12 64bit kernel, 32bit userspace: broken

ALSA 1.0.15:
2.6.24-rc6 64bit: broken (and half of the mixer settings are missing)


The soundcard is integrated to the motherboard (Abit IP35 Pro) and I can't 
find any more information on it than it is "7.1 CH HD Audio CODEC".


Relevant part of dmesg (it is the same for 32/64 bit versions, expect that 
the interrput goes to IRQ 18):

===cut dmesg
Advanced Linux Sound Architecture Driver Version 1.0.14 (Fri Jul 20 09:12:58 2007 UTC).
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1b.0 to 64
hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
usbcore: registered new interface driver snd-usb-audio
ALSA device list:
  #0: HDA Intel at 0xfdff4000 irq 22
===cut lspci
00:1b.0 Audio device [0403]: Intel Corporation 82801I (ICH9 Family) HD Audio Controller [8086:293e] (rev 02)
	Subsystem: ABIT Computer Corp. Unknown device [147b:1083]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 22
	Region 0: Memory at fdff4000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE- FLReset+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Virtual Channel
	Capabilities: [130] Root Complex Link
===cut asound/cards
 0 [Intel          ]: HDA-Intel - HDA Intel
                      HDA Intel at 0xfdff4000 irq 22
===cut

There are no differences in /proc/asound directory entries expect the cards 
file (different IRQ).


Any ideas how to fix this?


//T

