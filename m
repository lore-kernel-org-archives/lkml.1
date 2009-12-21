Return-Path: <linux-kernel-owner+w=401wt.eu-S1757035AbZLUTIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035AbZLUTIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 14:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757021AbZLUTIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 14:08:49 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:19996 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757007AbZLUTIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 14:08:48 -0500
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <4B2FC7B2.7000001@tremplin-utc.net>
Date: Mon, 21 Dec 2009 20:08:34 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091211 Mandriva/3.0-4mdv2010.1 (2010.1) Thunderbird/3.0
MIME-Version: 1.0
To: Maciej Rutecki <maciej.rutecki@gmail.com>
CC: Takashi Iwai <tiwai@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org, perex@perex.cz,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [2.6.33-rc1] [SOUND] HDA: high cpu usage, noise
References: <8db1092f0912200927y7cdab36ftd1f73d56cd89763f@mail.gmail.com>	 <s5hmy1cpqo4.wl%tiwai@suse.de> <8db1092f0912211012mcdd6639oaaf0bddc118e7d66@mail.gmail.com>
In-Reply-To: <8db1092f0912211012mcdd6639oaaf0bddc118e7d66@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 21-12-09 19:12, Maciej Rutecki schreef:
> 2009/12/21 Takashi Iwai <tiwai@suse.de>:
>> At Sun, 20 Dec 2009 18:27:45 +0100,
>> Maciej Rutecki wrote:
>>>
>>> Hi
>>>
>>> Affected kernel: 2.6.33-rc1
>>> Last known good: 2.6.32
>>
>> The only fundamental change, AFAIK, is the use of MSI as default.
>> Could you try to add enable_msi=0 option to snd-hda-intel?
>>
> 
> root@gumis:/# cat /sys/module/snd_hda_intel/parameters/enable_msi
> 0
> 
> Still the same:
> ps aux:
> 
> root      1117 27.4  0.0      0     0 ?        S    19:00   2:05 [hd-audio0]
> 
> I also notice short sound during booting system, when sound modules is
> loading.  I can try bisection, but in next week; already I don't have
> to much time.
Hello,
I've got the same problem here (high hd-audio0 usage + clicks in the
output sound).

Hardware is identical:
/proc/asound/pcm
00-00: AD198x Analog : AD198x Analog : playback 1 : capture 1

I haven't tried the enable_msi parameter but, just to give more info,
here is the log ("dmesg | grep -i hda") when the bug happens:
Dec 18 10:39:10 dutifh kernel: HDA Intel 0000:00:1b.0: power state
changed by ACPI to D0
Dec 18 10:39:10 dutifh kernel: HDA Intel 0000:00:1b.0: PCI INT A -> GSI
17 (level, low) -> IRQ 17
Dec 18 10:39:10 dutifh kernel: input: HDA Digital PCBeep as
/devices/pci0000:00/0000:00:1b.0/input/input12
Dec 18 10:39:10 dutifh kernel: hda-intel: azx_get_response timeout,
switching to polling mode: last cmd=0x006f0900

And here is with 2.6.32, working fine
Dec 18 11:46:03 dutifh kernel: HDA Intel 0000:00:1b.0: power state
changed by ACPI to D0
Dec 18 11:46:03 dutifh kernel: HDA Intel 0000:00:1b.0: PCI INT A -> GSI
17 (level, low) -> IRQ 17
Dec 18 11:46:03 dutifh kernel: input: HDA Digital PCBeep as
/devices/pci0000:00/0000:00:1b.0/input/input11

Could it be coming from this timeout?

Eric
