Return-Path: <linux-kernel-owner+w=401wt.eu-S1755208AbZCHVPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbZCHVPT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 17:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754278AbZCHVPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 17:15:05 -0400
Received: from smtp2.tech.numericable.fr ([82.216.111.38]:59768 "EHLO
	smtp2.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250AbZCHVPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 17:15:02 -0400
Message-ID: <49B43552.8080108@numericable.fr>
Date: Sun, 08 Mar 2009 22:14:58 +0100
From: etienne <etienne.basset@numericable.fr>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.29-rc7][REGRESSION][FOUND] sound broken on Creative Labs
 SB Audigy
References: <49B3AF45.8080209@numericable.fr> <s5h3adnyck8.wl%tiwai@suse.de>
In-Reply-To: <s5h3adnyck8.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> At Sun, 08 Mar 2009 12:43:01 +0100,
> etienne wrote:
>> Hi Takashi,
>>
>> on 2.6.29-rc7 my sound card Creative Labs SB Audigy doesn't work anymore
>> it worked in the previous -rc i tested (rc5)
>>
>> dmesg
>> EMU10K1_Audigy 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
>> Installing spdif_bug patch: SB Audigy 2 ZS [SB0353]
>>
>> cat /proc/asound/cards
>>  0 [Audigy2        ]: Audigy2 - SB Audigy 2 ZS [SB0353]
>>                       SB Audigy 2 ZS [SB0353] (rev.4, serial:0x10031102) at 0xcc80, irq 16
>>
>>
>> lscpi
>> 03:00.0 Multimedia audio controller: Creative Labs SB Audigy (rev 04)
>> lspci -vvv
>> 03:00.0 Multimedia audio controller: Creative Labs SB Audigy (rev 04)
>>         Subsystem: Creative Labs Device 1003
>>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
>>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 64 (500ns min, 5000ns max)
>>         Interrupt: pin A routed to IRQ 16
>>         Region 0: I/O ports at cc80 [size=64]
>>         Capabilities: <access denied>
>>         Kernel driver in use: EMU10K1_Audigy
>>         Kernel modules: snd-emu10k1
>>
>> i've use alsa-info.sh, my info is stored at
>>  http://www.alsa-project.org/db/?f=4460e77670d538196e11ae5e61e9b1f86fb9669b
>>
>>
>> if I revert the following commit, it works again
>>
>>
>> commit 1f9da5544073d38e05139f8ce9da24e78653c73e
>> Author: Takashi Iwai <tiwai@suse.de>
>> Date:   Tue Feb 24 15:31:02 2009 +0100
>>
>>     ALSA: emu10k1 - Fix digital/analog switch on audigy2 ZS
>>
>>     Fix the inverted logic of shared spdif switch.
>>
>>     Reference: Novell bnc#478496
>>         https://bugzilla.novell.com/show_bug.cgi?id=478496
>>
>>     Signed-off-by: Takashi Iwai <tiwai@suse.de>
> 
> Check "Audigy Analog/Digital Output Jack" switch.
> This must be *off* to output from the analog jacks.
> 
> Before the patch, it was wrongly implemented and the patch fixes
> the (long-standing wrong) logic.
> 
thanks, that works

Etienne

