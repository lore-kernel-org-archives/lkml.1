Return-Path: <linux-kernel-owner+w=401wt.eu-S1753007Ab0AYDqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab0AYDqM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 22:46:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696Ab0AYDqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 22:46:07 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:54025 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab0AYDqG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 22:46:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=VjTTIMkMWMIsB6w+oUpWv2aTQBjNmOjJKkzMfGgywMxtMeU1j7TzONwunGKhn4CDJQ
         uB0oKMPE2yM4WK8cWJWjtU6qPl6+nEY1K1SEx2nt5sm0iTpF32kx8COsjjbHk0FFwTc5
         Q8jlF6W9BMtBr9XVN755d14oCmOx+184zOLp0=
MIME-Version: 1.0
In-Reply-To: <20100124190820.GA12508@liondog.tnic>
References: <alpine.LFD.2.00.1001211535360.13231@localhost.localdomain>
	 <20100124111946.GA4170@liondog.tnic>
	 <alpine.LFD.2.00.1001241018500.3574@localhost.localdomain>
	 <20100124190820.GA12508@liondog.tnic>
Date: Sun, 24 Jan 2010 22:46:04 -0500
Message-ID: <a728f9f91001241946l64f40438gcf0705a2401bf2e3@mail.gmail.com>
Subject: Re: Linux 2.6.33-rc5
From: Alex Deucher <alexdeucher@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alex Deucher <alexdeucher@gmail.com>,
       Jerome Glisse <glisse@freedesktop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 24, 2010 at 2:08 PM, Borislav Petkov
<petkovbb@googlemail.com> wrote:
> On Sun, Jan 24, 2010 at 10:30:22AM -0800, Linus Torvalds wrote:
>> On Sun, 24 Jan 2010, Borislav Petkov wrote:
>> >
>> > 1. After suspend, the right monitor shows very funny colors, as if it is
>> > on crack, in contrast to the left one which looks fine:
>> >
>> > http://userweb.kernel.org/~bp/right_monitor.jpg
>> > http://userweb.kernel.org/~bp/left_monitor.jpg
>>
>> Ok, at a guess, it looks like something isn't restoring the palette
>> registers for the second output. You didn't say what GPU you have, but
>> judging by your CC list, it's a radeon. You might want to let the Radeon
>> KMS people know exactly what your setup is etc.
>
> Good guessing, it's a radeon HD 3600 series (RV635 chip), pci
> vendor/device id: 1002:9598, using radeonhd driver.

radeonhd does not support KMS, so if you have kms enabled, you will
likely run into issues as both the drm and radeonhd will be trying to
drive the hardware.  If you want to use KMS, use the radeon driver
(xf86-video-ati), otherwise, disabled KMS.

Alex

>
> More specifically,
>
> 01:00.0 VGA compatible controller: ATI Technologies Inc Mobility Radeon HD 3600 Series (prog-if 00 [VGA controller])
>        Subsystem: ASUSTeK Computer Inc. Device 01da
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR+ <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Interrupt: pin A routed to IRQ 18
>        Region 0: Memory at d0000000 (64-bit, prefetchable) [size=256M]
>        Region 2: Memory at feaf0000 (64-bit, non-prefetchable) [size=64K]
>        Region 4: I/O ports at d000 [size=256]
>        Expansion ROM at feac0000 [disabled] [size=128K]
>        Capabilities: [50] Power Management version 3
>                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
>                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
>                        ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>                        MaxPayload 128 bytes, MaxReadReq 128 bytes
>                DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
>                LnkCap: Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0 <64ns, L1 <1us
>                        ClockPM- Surprise- LLActRep- BwNot-
>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>                DevCap2: Completion Timeout: Not Supported, TimeoutDis-
>                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
>                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
>                         Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
>                         Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -6dB
>        Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
>                Address: 0000000000000000  Data: 0000
>        Capabilities: [100] Vendor Specific Information <?>
>
> X.org says:
>
> (II) Primary Device is: PCI 01@00:00:0
> (**) RADEONHD(0): Depth 24, (--) framebuffer bpp 32
> (**) RADEONHD(0): Option "AccelMethod" "exa"
> (**) RADEONHD(0): Option "DRI" "on"
> (**) RADEONHD(0): Selected EXA 2D acceleration.
> (II) RADEONHD(0): Card not in database: 0x9598:0x1043:0x01DA; using generic modesetting.
>        If - and only if - your card does not work or does not work optimally
>        please contact radeonhd@opensuse.org to help rectify this.
>        Use the subject: 0x9598:0x1043:0x01DA: <name of board>
>        and *please* describe the problems you are seeing
>        in your message.
> (--) RADEONHD(0): Detected an RV635 on an unidentified card
>
> config attached.
>
> --
> Regards/Gruss,
>    Boris.
>
