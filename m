Return-Path: <linux-kernel-owner+w=401wt.eu-S1765191AbYEOURa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765191AbYEOURa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 16:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758015AbYEOURT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 16:17:19 -0400
Received: from mailgw.infracomspa.it ([217.12.183.244]:2523 "EHLO
	svkmg019i.infracomspa.it" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1764661AbYEOURR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 16:17:17 -0400
Message-ID: <482C9A3E.3000009@infracom.it>
Date: Thu, 15 May 2008 22:17:02 +0200
From: Roberto Oppedisano <roberto.oppedisano@infracom.it>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080420)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Stas Sergeev <stsp@aknet.ru>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Non-working snd-pcsp
References: <482737BE.20502@infracom.it>	<4827415A.7060101@aknet.ru>	<482756F0.8020609@infracom.it>	<48275D8D.10500@aknet.ru>	<4827F0A1.9090600@infracom.it>	<48288ACC.1020909@aknet.ru>	<48299F08.2060702@infracom.it>	<4829B6A1.90707@infracom.it>	<s5h7idycfmf.wl%tiwai@suse.de>	<482A7A17.8070706@infracom.it> <s5hwslxb3t8.wl%tiwai@suse.de>
In-Reply-To: <s5hwslxb3t8.wl%tiwai@suse.de>
X-Enigmail-Version: 0.95.0
X-MIMETrack: Itemize by SMTP Server on Venere/InfracomSpA/IT(Release 6.5.6|March 06, 2007) at
 05/15/2008 10:17:11 PM,
	Serialize by Router on Bacco/InfracomSpA/IT(Release 6.5.6|March 06, 2007) at
 15/05/2008 22.17.16,
	Serialize complete at 15/05/2008 22.17.16
X-TM-AS-Product-Ver: <SMD>-<3.0.1.3628>-<5.5.1026>-<15894>
X-TM-AS-Result: <No>-<-10017.988>-<5.0>-<99000>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> At Wed, 14 May 2008 07:35:19 +0200,
> Roberto Oppedisano wrote:
>   
>> Hello.
>>
>> Takashi Iwai wrote:
>>     
>>> [Changed the subject since it's no real regression]
>>>       
>> ACK
>>     
>>> Could you run "alsactl -f somefile store" and show that file?
>>> This will contain the full mixer information.  
>>>       
>> Attached.
>>     
>
> You turned off both "Master Playback Switch" and "PC Speaker Playback
> Switch" of snd-pcsp driver.  Then it cannot work.
>
> And, since you loaded the sound driver for on-board sound chip, you'll
> likely have to adjust the mixer of that driver, too.  The beep can be
> hooked to the on-board chip once after initialized.
>   

I tried different switch combination with  alsamixer, but no still no
sound from the speaker...
(I managed to enable the speaker, following Stas suggestion)

> But I'm wondering why "PC Speaker Playback Switch" and Volume don't
> appear in the on-board driver.  Which codec (I suppose it's AC97) on
> it?
>   
yep.

00:1f.5 Multimedia audio controller: Intel Corporation 82801DB/DBL/DBM
(ICH4/ICH4-L/ICH4-M) AC'97 Audio Controller (rev 01)

>>>> With kmix I can toggle the mute setting (alsamixer still sees it off), but
>>>> no sound comes out from the speaker.
>>>> I also tried
>>>>
>>>> echo -e "\a"
>>>>
>>>> without the module loaded (on old kernel), and the speaker is mute.
>>>>     
>>>>         
>>> When snd-pcsp is built, the input pcspkr is excluded.  So, the beep
>>> won't work unless snd-pcsp is loaded and activated.
>>>   
>>>       
>> I tried this on 2.6.25 where:
>>
>> roppedisano@poppero1:~$ grep PCSP /boot/config-2.6.25
>> roppedisano@poppero1:~$
>>
>> So, if I'm not missing something, I think it should have worked
>>     
>
> Weird.  If CONFIG_INPUT_PCSPKR isn't there, the box shouldn't beep at
> all.  If it still beeps, it must be a bug...
I can confirm that the box doesn't beep.

Kind regards

R
