Return-Path: <linux-kernel-owner+w=401wt.eu-S1761777AbYCUUhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761777AbYCUUhc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 16:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759392AbYCUUhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 16:37:21 -0400
Received: from smtp106.biz.mail.re2.yahoo.com ([206.190.52.175]:24046 "HELO
	smtp106.biz.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755226AbYCUUhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 16:37:20 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Mar 2008 16:37:20 EDT
X-YMail-OSG: OOuTgs4VM1nJfOzpApTKWCnuCUKTDHRyChykYrMb6OBlurXp
X-Yahoo-Newman-Property: ymail-3
Message-ID: <47E41AEB.2060901@embeddedalley.com>
Date: Fri, 21 Mar 2008 16:30:35 -0400
From: Matthew Ranostay <mranostay@embeddedalley.com>
Organization: Embedded Alley Solutions Inc
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Andre Tomt <andre@tomt.net>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-git regression with snd-hda-intel on Dell XPS M1330, no
 analog sound
References: <47E40684.2030608@tomt.net>
In-Reply-To: <47E40684.2030608@tomt.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andre Tomt wrote:
> [Rafael & Matthew: this is a resend - original was sent to wrong
> linux-kernel address. Also updated, so just ignore the earlier emails.]
> 
> With 2.6.25-git I lost sound on my Dell XPS M1330 laptop. There seems to
> be two issues at hand here: 1. Analog output is listed, but emits no
> sound (just silence), and 2. Digital out device is missing.
> 
Ok this is puzzling can you paste the results of 'cat /proc/asound/card0/codec0#*'?

Thanks,

Matthew Ranostay

> Issue #1 is bisected in this thread. #2 is still work in progress, and
> will be posted as a separate thread.
> 
> git bisect nailed down the missing audio issue to this commit:
>> 2f32d909f3a85a96074801f6cf20f93324f87646 is first bad commit
>> commit 2f32d909f3a85a96074801f6cf20f93324f87646
>> Author: Matthew Ranostay <mranostay@embeddedalley.com>
>> Date:   Thu Jan 10 13:06:26 2008 +0100
>>
>>     [ALSA] hda: STAC9228 VT fixes
>>
>>     Moved 2 systems PCI_QUIRK values to STAC_DELL_BIOS. Also the second
>>     front HP jack is incorrect defined in the BIOS VT's for some laptops,
>>     this patch corrects this.
>>
>>     Signed-off-by: Matthew Ranostay <mranostay@embeddedalley.com>
>>     Signed-off-by: Takashi Iwai <tiwai@suse.de>
>>     Signed-off-by: Jaroslav Kysela <perex@perex.cz>
>>
>> :040000 040000 98d7878c8addc0b1595d4b42524cf9cb6cf8759a
>> e32416d5e02694320e8aac369b260d86b2eb2508 M   sound
> 
> lspci:
>> 00:1b.0 Audio device [0403]: Intel Corporation 82801H (ICH8 Family) HD
>> Audio Controller [8086:284b] (rev 02)
>>         Subsystem: Dell Unknown device [1028:0209]
>>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>> ParErr- Stepping- SERR+ FastB2B- DisINTx+
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 0, Cache Line Size: 64 bytes
>>         Interrupt: pin A routed to IRQ 217
>>         Region 0: Memory at febfc000 (64-bit, non-prefetchable)
>> [size=16K]
>>         Capabilities: [50] Power Management version 2
>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA
>> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>         Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+
>> Queue=0/0 Enable+
>>                 Address: 00000000fee0300c  Data: 414a
>>         Capabilities: [70] Express (v1) Root Complex Integrated
>> Endpoint, MSI 00
>>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
>> unlimited, L1 unlimited
>>                         ExtTag- RBE- FLReset-
>>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
>> Unsupported-
>>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
>>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
>>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
>> AuxPwr+ TransPend-
>>                 LnkCap: Port #0, Speed unknown, Width x0, ASPM
>> unknown, Latency L0 <64ns, L1 <1us
>>                         ClockPM- Suprise- LLActRep- BwNot-
>>                 LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>                 LnkSta: Speed unknown, Width x0, TrErr- Train-
>> SlotClk- DLActive- BWMgmt- ABWMgmt-
>>         Capabilities: [100] Virtual Channel <?>
>>         Capabilities: [130] Root Complex Link <?>
>>         Kernel driver in use: HDA Intel
>>         Kernel modules: snd-hda-intel
>> 00: 86 80 4b 28 06 05 10 00 02 00 03 04 10 00 00 00
>> 10: 04 c0 bf fe 00 00 00 00 00 00 00 00 00 00 00 00
>> 20: 00 00 00 00 00 00 00 00 00 00 00 00 28 10 09 02
>> 30: 00 00 00 00 50 00 00 00 00 00 00 00 0a 01 00 00
>> 40: 01 00 00 03 00 00 00 00 00 00 00 00 00 00 00 00
>> 50: 01 60 42 c8 00 00 00 00 00 00 00 00 00 00 00 00
>> 60: 05 70 81 00 0c 30 e0 fe 00 00 00 00 4a 41 00 00
>> 70: 10 00 91 00 c0 0f 00 00 00 08 10 00 00 00 00 00
>> 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> c0: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00
>> d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> f0: 00 00 00 00 00 00 00 00 86 0f 05 00 00 00 00 00
> 
> 
> 

