Return-Path: <linux-kernel-owner+w=401wt.eu-S1422986AbXCGSvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422986AbXCGSvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 13:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422987AbXCGSvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 13:51:18 -0500
Received: from smtp.osdl.org ([65.172.181.24]:49076 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422986AbXCGSvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 13:51:14 -0500
Date: Wed, 7 Mar 2007 10:47:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Randy Cushman <rcushman_linux@earthlink.net>, Takashi Iwai <tiwai@suse.de>,
       Jaroslav Kysela <perex@suse.cz>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: mm snapshot broken-out-2007-03-05-02-22.tar.gz uploaded
Message-Id: <20070307104746.f08a2e84.akpm@linux-foundation.org>
In-Reply-To: <45EEA3C4.7000501@googlemail.com>
References: <200703051024.l25AOIF3015951@shell0.pdx.osdl.net>
	<45EC2DEB.1050108@googlemail.com>
	<45EEA3C4.7000501@googlemail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Mar 2007 12:36:36 +0100 Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> Michal Piotrowski napisał(a):
> > Hi,
> > 
> > akpm@linux-foundation.org napisał(a):
> >> The mm snapshot broken-out-2007-03-05-02-22.tar.gz has been uploaded to
> >>
> >>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-03-05-02-22.tar.gz
> >>
> >> It contains the following patches against 2.6.21-rc2:
> >>
> > 
> > Outstanding issue - my 3d surround doesn't work since 2.6.20.
> > 
> > I'll bisect this commits
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=724339d76d9407cd1a8ad32a9c1fdf64840cc51b
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=6026179519896e7d35b2564e7544487d1c8948e7
> > 
> > 00:1f.5 Multimedia audio controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) AC'97 Audio Controller (rev 02)
> >         Subsystem: ASUSTeK Computer Inc. P4P800 Mainboard
> >         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> >         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> >         Latency: 0
> >         Interrupt: pin B routed to IRQ 17
> >         Region 0: I/O ports at d000 [size=256]
> >         Region 1: I/O ports at d400 [size=64]
> >         Region 2: Memory at f5fff800 (32-bit, non-prefetchable) [size=512]
> >         Region 3: Memory at f5fff400 (32-bit, non-prefetchable) [size=256]
> >         Capabilities: [50] Power Management version 2
> >                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
> >                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> > 
> > Advanced Linux Sound Architecture Driver Version 1.0.14rc2 (Wed Feb 14 07:42:13 2007 UTC).
> > 
> > CONFIG_SND=m
> > CONFIG_SND_TIMER=m
> > CONFIG_SND_PCM=m
> > CONFIG_SND_RAWMIDI=m
> > CONFIG_SND_SEQUENCER=m
> > CONFIG_SND_SEQ_DUMMY=m
> > CONFIG_SND_OSSEMUL=y
> > CONFIG_SND_MIXER_OSS=m
> > CONFIG_SND_PCM_OSS=m
> > CONFIG_SND_PCM_OSS_PLUGINS=y
> > CONFIG_SND_SEQUENCER_OSS=y
> > CONFIG_SND_RTCTIMER=m
> > CONFIG_SND_SEQ_RTCTIMER_DEFAULT=y
> > # CONFIG_SND_DYNAMIC_MINORS is not set
> > CONFIG_SND_SUPPORT_OLD_API=y
> > CONFIG_SND_VERBOSE_PROCFS=y
> > # CONFIG_SND_VERBOSE_PRINTK is not set
> > # CONFIG_SND_DEBUG is not set
> > 
> > CONFIG_SND_AC97_CODEC=m
> > CONFIG_SND_DUMMY=m
> > CONFIG_SND_VIRMIDI=m
> > 
> > CONFIG_SND_INTEL8X0=m
> 
> As I said above, center and rear speakers doesn't work with this patch.
> 
> $ git-bisect good
> 831466f4ad2b5fe23dff77edbe6a7c244435e973 is first bad commit
> commit 831466f4ad2b5fe23dff77edbe6a7c244435e973
> Author: Randy Cushman <rcushman_linux@earthlink.net>
> Date:   Tue Dec 19 18:42:16 2006 +0100
> 
>     [ALSA] ac97 - fix microphone and line_in selection logic
> 
>     This patch fixes the Microphone and LINE_IN select logic for
>     Analog Devices surround codecs with shared jacks.  The existing
>     code can never utilize the shared jacks for Microphone and LINE_IN
>     due to the reversed jack selection logic.  The patched code
>     correctly selects the shared jack for input if the 'Channel Mode'
>     selector does not specify that the jack is to be used for output.
>     Specifically, in '2ch' mode the Center/LFE jack is used for
>     microphone input and the Surround jack is used for LINE_IN,
>     in '4ch' mode the Center/LFE jack is used for microphone input
>     and the Surround jack is used for output, and in '6ch' mode
>     both jacks are used for output.
> 
>     Signed-off-by: Randy Cushman <rcushman_linux@earthlink.net>
>     Signed-off-by: Takashi Iwai <tiwai@suse.de>
>     Signed-off-by: Jaroslav Kysela <perex@suse.cz>
> 

Is 2.6.21-rc3 similarly broken?

This patch reverts cleanly if needed. 
