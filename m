Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbZCJMbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbZCJMbb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 08:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754887AbZCJMbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 08:31:06 -0400
Received: from india.einfochips.com ([203.88.139.151]:12419 "EHLO
	ahmedabad.einfochips.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754603AbZCJMbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 08:31:04 -0400
Message-ID: <49B65B96.5080108@einfochips.com>
Date: Tue, 10 Mar 2009 17:52:46 +0530
From: Viral Mehta <viral.mehta@einfochips.com>
Organization: eIbfochips Ltd.
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>, perex@perex.cz,
       Linux audio dev <linux-audio-dev@lists.linuxaudio.org>
CC: Clemens Ladisch <clemens@ladisch.de>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH] [SOUND] recording gain control
References: <49B5F8F5.8040100@einfochips.com>	<49B62C1D.4080509@ladisch.de> <s5h1vt5k1xp.wl%tiwai@suse.de>
In-Reply-To: <s5h1vt5k1xp.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> At Tue, 10 Mar 2009 10:00:13 +0100,
> Clemens Ladisch wrote:
>   
>> (CC alsa-devel)
>>
>> Viral Mehta wrote:
>>     
>>> Hi,
>>>
>>> I am trying to do gain control while RECORDING for my Audio Mic device.
>>>
>>> My application opens /dev/mixer device and calls ioctl(fdmixer, 
>>> MIXER_WRITE(SOUND_MIXER_MIC), ...)
>>>
>>> But, the call fails. It traces to sound/core/oss/mixer_oss.c file and 
>>> snd_mixer_oss_put_volume1() function.
>>> It never falls in "if (slot->present & SNDRV_MIXER_OSS_PRESENT_CVOLUME)" 
>>> as condition "if (slot->present & SNDRV_MIXER_OSS_PRESENT_PVOLUME) " 
>>> comes as false.
>>>
>>> I think there is a bug in kernel and I think it should be like as below,
>>>
>>> --- sound/core/oss/mixer_oss.c  2008-12-03 13:24:02.000000000 +0530
>>> +++ sound/core/oss/mixer_oss.c   2009-03-09 16:22:06.548766896 +0530
>>> @@ -688,7 +688,7 @@ static int snd_mixer_oss_put_volume1(str
>>>
>>>      if (slot->present & SNDRV_MIXER_OSS_PRESENT_PVOLUME) {
>>>              snd_mixer_oss_put_volume1_vol(fmixer, pslot, 
>>> slot->numid[SNDRV_MIXER_OSS_ITEM_PVOLUME], left, right);
>>> -               if (slot->present & SNDRV_MIXER_OSS_PRESENT_CVOLUME)
>>> +       } else if (slot->present & SNDRV_MIXER_OSS_PRESENT_CVOLUME) {
>>>                      snd_mixer_oss_put_volume1_vol(fmixer, pslot, 
>>> slot->numid[SNDRV_MIXER_OSS_ITEM_CVOLUME], left, right);
>>>      } else if (slot->present & SNDRV_MIXER_OSS_PRESENT_GVOLUME) {
>>>              snd_mixer_oss_put_volume1_vol(fmixer, pslot, 
>>> slot->numid[SNDRV_MIXER_OSS_ITEM_GVOLUME], left, right);
>>>       
>> Your mailer mangled the patch; see linux/Documentation/email-clients.txt.
>>     
>
> Also, the current code behaves intentionally so (as it's designed for
> mic-loopback volume).
>
> A more feasible fix would be to add another if check for *_CVOLUME
> instead of moving it.
>
>
>   
Oh okie. It makes sense.
I just sent out a patch on LAD. Should I resubmit with what you proposed ?

> Takashi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
> Email Scanned for Virus & Dangerous Content by : www.CleanMailGateway.com
>
>
>   
-- 
_____________________________________________________________________
Disclaimer: This e-mail message and all attachments transmitted with it
are intended solely for the use of the addressee and may contain legally
privileged and confidential information. If the reader of this message
is not the intended recipient, or an employee or agent responsible for
delivering this message to the intended recipient, you are hereby
notified that any dissemination, distribution, copying, or other use of
this message or its attachments is strictly prohibited. If you have
received this message in error, please notify the sender immediately by
replying to this message and please delete it from your computer. Any
views expressed in this message are those of the individual sender
unless otherwise stated.Company has taken enough precautions to prevent
the spread of viruses. However the company accepts no liability for any
damage caused by any virus transmitted by this email.
__________________________________________________________________________
 
