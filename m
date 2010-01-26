Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692Ab0AZSWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab0AZSWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 13:22:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754704Ab0AZSWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 13:22:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57586 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932132Ab0AZSWC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 13:22:02 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: sboyce@blueyonder.co.uk
Subject: Re: HDA Intel Audio hang on boot
Date: Tue, 26 Jan 2010 19:22:35 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: Takashi Iwai <tiwai@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera> <s5h636puit8.wl%tiwai@suse.de> <4B5EF1B7.3090800@blueyonder.co.uk>
In-Reply-To: <4B5EF1B7.3090800@blueyonder.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001261922.35213.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 January 2010, Sid Boyce wrote:
> On 26/01/10 12:55, Takashi Iwai wrote:
> > At Tue, 26 Jan 2010 12:02:44 +0000,
> > Sid Boyce wrote:
> >>
> >> On 26/01/10 06:58, Takashi Iwai wrote:
> >>> At Tue, 26 Jan 2010 07:40:03 +0100,
> >>> I wrote:
> >>>>
> >>>> At Tue, 26 Jan 2010 00:59:15 +0000,
> >>>> Sid Boyce wrote:
> >>>>>
> >>>>> On 25/01/10 21:55, Takashi Iwai wrote:
> >>>>>> At Mon, 25 Jan 2010 22:54:23 +0100,
> >>>>>> I wrote:
> >>>>>>>
> >>>>>>> At Mon, 25 Jan 2010 22:39:02 +0100,
> >>>>>>> Rafael J. Wysocki wrote:
> >>>>>>>>
> >>>>>>>> On Monday 25 January 2010, Sid Boyce wrote:
> >>>>>>>>> On 15/01/10 01:24, Sid Boyce wrote:
> >>>>>>>>> This is the only outstanding bug. No problems up 2.6.32-git1, but I get
> >>>>>>>>> a solid lock-up on 2.6.32-git2 through 2.6.33-rc5 if the on-board audio
> >>>>>>>>> is not disabled in the BIOS.
> >>>>>>>>
> >>>>>>>> I guess we should let Takashi know.
> >>>>>>>
> >>>>>>> Thanks.
> >>>>>>>
> >>>>>>>>>> tindog:~ # uname -r
> >>>>>>>>>> 2.6.33-rc4-smp
> >>>>>>>>>> On 2.6.32-git1 which boots, hwinfo shows:-
> >>>>>>>>>>   oss.card_id = 'HDA NVidia'
> >>>>>>>>>>   oss.card_id = 'HDA NVidia'
> >>>>>>>>>>   oss.card_id = 'HDA NVidia'
> >>>>>>>>>>   alsa.card_id = 'HDA NVidia'
> >>>>>>>>>>   alsa.card_id = 'HDA NVidia'
> >>>>>>>>>>   alsa.card_id = 'HDA NVidia'
> >>>>>>>>>>   alsa.card_id = 'HDA NVidia'
> >>>>>>>>>>   info.product = 'HDA NVidia ALSA hardware specific Device'
> >>>>>>>>>>   alsa.card_id = 'HDA NVidia'
> >>>>>>>>>>   info.product = 'HDA NVidia ALSA Control Device'
> >>>>>>>>>>   alsa.card_id = 'HDA NVidia'
> >>>>>>>>>>   info.product = 'HDA NVidia Sound Card'
> >>>>>>>>>>   sound.card_id = 'HDA NVidia'
> >>>>>>>>>>   info.linux.driver = 'HDA Intel'
> >>>>>>>>>>     22:     489835        578   IO-APIC-fasteoi   sata_nv, HDA Intel
> >>>>>>>>>>        HDA Intel: /devices/pci0000:00/0000:00:0e.1
> >>>>>>>>>>        HDA Intel: module = snd_hda_intel
> >>>>>>>>>> irq:0 22 (   490413) "sata_nv" "HDA Intel"
> >>>>>>>>>>        HDA Intel: /devices/pci0000:00/0000:00:0e.1
> >>>>>>>>>>        HDA Intel: module = snd_hda_intel
> >>>>>>>>>>        HDA Intel: /devices/pci0000:00/0000:00:0e.1
> >>>>>>>>>>        HDA Intel: module = snd_hda_intel
> >>>>>>>>>>   E: DRIVER=HDA Intel
> >>>>>>>>>>   <6>HDA Intel 0000:00:0e.1: PCI INT B -> Link[AAZA] -> GSI 22 (level,
> >>>>>>>>>> low) -> IRQ 22
> >>>>>>>>>>   <7>HDA Intel 0000:00:0e.1: setting latency timer to 64
> >>>>>>>>>>   Driver: "HDA Intel"
> >>>>>>>
> >>>>>>> What I'd try first is to pass enable_msi=0 option.
> >>>>>>
> >>>>>> Just to be sure -- it's an option for snd-hda-intel module.
> >>>>>>
> >>>>>>
> >>>>>> Takashi
> >>>>>>
> >>>>>
> >>>>> I passed "modprobe snd-hda-intel enable_msi=0" on the kernel command
> >>>>> line,
> >>>
> >>> Oh, I overlooked this text.  Of course, this can't work :)
> >>>
> >>> "modprobe..." isn't for the kernel command line but for modprobe
> >>> configs, usually specified in /etc/modprobe.d/* file.
> >>>
> >> I had already tried that... it locks up at the same point also with
> >> "enable_msi=1".
> >> tindog:/etc/modprobe.d # less 50-sound.conf
> >>
> >> options snd slots=snd-hda-intel,enable_msi=0
> > 
> > This is the option for module snd, not snd-hda-intel.
> > 
> > 
> > Takashi
> > 
> options snd,enable_msi=0 slots=snd-hda-intel

options snd enable_msi=0 slots=snd-hda-intel

(ie. the comma shouldn't be present in there).

> # 9LTX.vLXC8EvZgR7:MCP55 High Definition Audio
> alias snd-card-0 snd-hda-intel

Rafael
