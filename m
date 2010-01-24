Return-Path: <linux-kernel-owner+w=401wt.eu-S1752616Ab0AXTIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab0AXTIc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 14:08:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967Ab0AXTIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 14:08:30 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:23976 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab0AXTI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 14:08:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=DkU35jU33l1k7elJhMLwiLKdQuo/ggwWFJtHJvY1loeOO4OuQI0syqMwezDjmuKGKf
         ios7vUs4Xn5K0i2otXVkPEeu1mbEMkeSIpBMZ6rOF8u/g7Rm5K32kqFFAiZePCNCxSyl
         rV1Fl2dAZ1VSLgmK42suV7mt6wYomJP5Q+v5I=
Date: Sun, 24 Jan 2010 20:08:20 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alex Deucher <alexdeucher@gmail.com>,
       Jerome Glisse <glisse@freedesktop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: Linux 2.6.33-rc5
Message-ID: <20100124190820.GA12508@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Alex Deucher <alexdeucher@gmail.com>,
	Jerome Glisse <glisse@freedesktop.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>
References: <alpine.LFD.2.00.1001211535360.13231@localhost.localdomain>
 <20100124111946.GA4170@liondog.tnic>
 <alpine.LFD.2.00.1001241018500.3574@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="IJpNTDwzlM2Ie8A6"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1001241018500.3574@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Sun, Jan 24, 2010 at 10:30:22AM -0800, Linus Torvalds wrote:
> On Sun, 24 Jan 2010, Borislav Petkov wrote:
> > 
> > 1. After suspend, the right monitor shows very funny colors, as if it is
> > on crack, in contrast to the left one which looks fine:
> > 
> > http://userweb.kernel.org/~bp/right_monitor.jpg
> > http://userweb.kernel.org/~bp/left_monitor.jpg
> 
> Ok, at a guess, it looks like something isn't restoring the palette 
> registers for the second output. You didn't say what GPU you have, but 
> judging by your CC list, it's a radeon. You might want to let the Radeon 
> KMS people know exactly what your setup is etc.

Good guessing, it's a radeon HD 3600 series (RV635 chip), pci
vendor/device id: 1002:9598, using radeonhd driver.

More specifically,

01:00.0 VGA compatible controller: ATI Technologies Inc Mobility Radeon HD 3600 Series (prog-if 00 [VGA controller])
        Subsystem: ASUSTeK Computer Inc. Device 01da
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR+ <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at d0000000 (64-bit, prefetchable) [size=256M]
        Region 2: Memory at feaf0000 (64-bit, non-prefetchable) [size=64K]
        Region 4: I/O ports at d000 [size=256]
        Expansion ROM at feac0000 [disabled] [size=128K]
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
                        ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0 <64ns, L1 <1us
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Not Supported, TimeoutDis-
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
                         Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -6dB
        Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [100] Vendor Specific Information <?>

X.org says:

(II) Primary Device is: PCI 01@00:00:0
(**) RADEONHD(0): Depth 24, (--) framebuffer bpp 32
(**) RADEONHD(0): Option "AccelMethod" "exa"
(**) RADEONHD(0): Option "DRI" "on"
(**) RADEONHD(0): Selected EXA 2D acceleration.
(II) RADEONHD(0): Card not in database: 0x9598:0x1043:0x01DA; using generic modesetting.
        If - and only if - your card does not work or does not work optimally
        please contact radeonhd@opensuse.org to help rectify this.
        Use the subject: 0x9598:0x1043:0x01DA: <name of board>
        and *please* describe the problems you are seeing
        in your message.
(--) RADEONHD(0): Detected an RV635 on an unidentified card

config attached.

-- 
Regards/Gruss,
    Boris.

--IJpNTDwzlM2Ie8A6
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="config.gz"
Content-Transfer-Encoding: base64

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

--IJpNTDwzlM2Ie8A6--
