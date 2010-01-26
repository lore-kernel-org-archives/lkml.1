Return-Path: <linux-kernel-owner+w=401wt.eu-S1753122Ab0AZMCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab0AZMCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 07:02:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752498Ab0AZMCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 07:02:51 -0500
Received: from smtp-out4.blueyonder.co.uk ([195.188.213.7]:43546 "EHLO
	smtp-out4.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752432Ab0AZMCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 07:02:50 -0500
Message-ID: <4B5ED9E4.60106@blueyonder.co.uk>
Date: Tue, 26 Jan 2010 12:02:44 +0000
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.14 Thunderbird/3.0 ThunderBrowse/3.2.7
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: HDA Intel Audio hang on boot
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera>	<4B4FC3B0.9070207@blueyonder.co.uk>	<4B5CF87A.20101@blueyonder.co.uk>	<201001252239.03017.rjw@sisk.pl>	<s5h8wblc0kw.wl%tiwai@suse.de>	<s5h7hr5c0jn.wl%tiwai@suse.de>	<4B5E3E63.80305@blueyonder.co.uk>	<s5htyu99xoc.wl%tiwai@suse.de> <s5hr5pd9wsu.wl%tiwai@suse.de>
In-Reply-To: <s5hr5pd9wsu.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/01/10 06:58, Takashi Iwai wrote:
> At Tue, 26 Jan 2010 07:40:03 +0100,
> I wrote:
>>
>> At Tue, 26 Jan 2010 00:59:15 +0000,
>> Sid Boyce wrote:
>>>
>>> On 25/01/10 21:55, Takashi Iwai wrote:
>>>> At Mon, 25 Jan 2010 22:54:23 +0100,
>>>> I wrote:
>>>>>
>>>>> At Mon, 25 Jan 2010 22:39:02 +0100,
>>>>> Rafael J. Wysocki wrote:
>>>>>>
>>>>>> On Monday 25 January 2010, Sid Boyce wrote:
>>>>>>> On 15/01/10 01:24, Sid Boyce wrote:
>>>>>>> This is the only outstanding bug. No problems up 2.6.32-git1, but I get
>>>>>>> a solid lock-up on 2.6.32-git2 through 2.6.33-rc5 if the on-board audio
>>>>>>> is not disabled in the BIOS.
>>>>>>
>>>>>> I guess we should let Takashi know.
>>>>>
>>>>> Thanks.
>>>>>
>>>>>>>> tindog:~ # uname -r
>>>>>>>> 2.6.33-rc4-smp
>>>>>>>> On 2.6.32-git1 which boots, hwinfo shows:-
>>>>>>>>   oss.card_id = 'HDA NVidia'
>>>>>>>>   oss.card_id = 'HDA NVidia'
>>>>>>>>   oss.card_id = 'HDA NVidia'
>>>>>>>>   alsa.card_id = 'HDA NVidia'
>>>>>>>>   alsa.card_id = 'HDA NVidia'
>>>>>>>>   alsa.card_id = 'HDA NVidia'
>>>>>>>>   alsa.card_id = 'HDA NVidia'
>>>>>>>>   info.product = 'HDA NVidia ALSA hardware specific Device'
>>>>>>>>   alsa.card_id = 'HDA NVidia'
>>>>>>>>   info.product = 'HDA NVidia ALSA Control Device'
>>>>>>>>   alsa.card_id = 'HDA NVidia'
>>>>>>>>   info.product = 'HDA NVidia Sound Card'
>>>>>>>>   sound.card_id = 'HDA NVidia'
>>>>>>>>   info.linux.driver = 'HDA Intel'
>>>>>>>>     22:     489835        578   IO-APIC-fasteoi   sata_nv, HDA Intel
>>>>>>>>        HDA Intel: /devices/pci0000:00/0000:00:0e.1
>>>>>>>>        HDA Intel: module = snd_hda_intel
>>>>>>>> irq:0 22 (   490413) "sata_nv" "HDA Intel"
>>>>>>>>        HDA Intel: /devices/pci0000:00/0000:00:0e.1
>>>>>>>>        HDA Intel: module = snd_hda_intel
>>>>>>>>        HDA Intel: /devices/pci0000:00/0000:00:0e.1
>>>>>>>>        HDA Intel: module = snd_hda_intel
>>>>>>>>   E: DRIVER=HDA Intel
>>>>>>>>   <6>HDA Intel 0000:00:0e.1: PCI INT B -> Link[AAZA] -> GSI 22 (level,
>>>>>>>> low) -> IRQ 22
>>>>>>>>   <7>HDA Intel 0000:00:0e.1: setting latency timer to 64
>>>>>>>>   Driver: "HDA Intel"
>>>>>
>>>>> What I'd try first is to pass enable_msi=0 option.
>>>>
>>>> Just to be sure -- it's an option for snd-hda-intel module.
>>>>
>>>>
>>>> Takashi
>>>>
>>>
>>> I passed "modprobe snd-hda-intel enable_msi=0" on the kernel command
>>> line,
> 
> Oh, I overlooked this text.  Of course, this can't work :)
> 
> "modprobe..." isn't for the kernel command line but for modprobe
> configs, usually specified in /etc/modprobe.d/* file.
> 
I had already tried that... it locks up at the same point also with
"enable_msi=1".
tindog:/etc/modprobe.d # less 50-sound.conf

options snd slots=snd-hda-intel,enable_msi=0
# mDsH.vLXC8EvZgR7:MCP55 High Definition Audio
alias snd-card-0 snd-hda-intel

> And... is this report for 2.6.32 or for 2.6.33?
> If it's with 2.6.32, enable_msi=1 may help instead.
> 
> 
The motherboard giving the problem is the Asus M2N32-SLI deluxe.
00:0e.1 Audio device: nVidia Corporation MCP55 High Definition Audio
(rev a2)

No such problem with the Asus CROSSHAIR II FORMULA motherboard which
also has the
00:07.0 Audio device: nVidia Corporation MCP72XE/MCP72P/MCP78U/MCP78S
High Definition Audio (rev a1)

For any kernel >2.6.32-git1 it hangs, i.e 2.6.32-git2 to 2.6.33-rc5.
Disabling the sound chip in the BIOS, they all boot.
tindog:/etc/modprobe.d # uname -r
2.6.32-git1-smp
tindog:/etc/modprobe.d # l /dev/dsp*
crw-rw-rw- 1 root audio 14,  3 Jan 26 11:46 /dev/dsp
crw-rw-rw- 1 root audio 14, 35 Jan 26 11:46 /dev/dsp2

> Takashi
> 
Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

