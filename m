Return-Path: <linux-kernel-owner+w=401wt.eu-S1759252AbYELHYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759252AbYELHYd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 03:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756182AbYELHYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 03:24:25 -0400
Received: from mailgw.infracomspa.it ([217.12.183.244]:3490 "EHLO
	svkmg019i.infracomspa.it" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756119AbYELHYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 03:24:24 -0400
Message-ID: <4827F0A1.9090600@infracom.it>
Date: Mon, 12 May 2008 09:24:17 +0200
From: Roberto Oppedisano <roberto.oppedisano@infracom.it>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080420)
MIME-Version: 1.0
To: Stas Sergeev <stsp@aknet.ru>
CC: LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>
Subject: Re: 2.6.26-rc1 regression: e5e1d3cb20034a3cbcfff1f0bae12201aa2ce17e
 breaks artsd
References: <482737BE.20502@infracom.it> <4827415A.7060101@aknet.ru> <482756F0.8020609@infracom.it> <48275D8D.10500@aknet.ru>
In-Reply-To: <48275D8D.10500@aknet.ru>
X-Enigmail-Version: 0.95.0
X-MIMETrack: Itemize by SMTP Server on Venere/InfracomSpA/IT(Release 6.5.6|March 06, 2007) at
 05/12/2008 09:24:16 AM,
	Serialize by Router on Bacco/InfracomSpA/IT(Release 6.5.6|March 06, 2007) at
 12/05/2008 09.24.23,
	Serialize complete at 12/05/2008 09.24.23
X-TM-AS-Product-Ver: <SMD>-<3.0.1.3628>-<5.5.1026>-<15894>
X-TM-AS-Result: <No>-<-10014.304>-<5.0>-<99000>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Stas Sergeev wrote:
> Roberto Oppedisano wrote:
>   
>>> cat /proc/asound/cards
>>>   
>>>       
>>  0 [pcsp           ]: PC-Speaker - pcsp
>>                       Internal PC-Speaker at port 0x61
>>  1 [I82801DBICH4   ]: ICH4 - Intel 82801DB-ICH4
>>                       Intel 82801DB-ICH4 with AD1981B at irq 10
>>  2 [Modem          ]: ICH-MODEM - Intel 82801DB-ICH4 Modem
>>                       Intel 82801DB-ICH4 Modem at irq 10
>>     
>>> I guess you simply got the pc-speaker driver
>>> loaded first and became your primary sound
>>> driver, which is not what you want.
>>>       
>> yes, that's true. Anyway in this case the sound server crashes with a
>> signal 6.
>>     
> I can't say for sure why does the
> crash happen, but what is known is
> that you need a very recent alsa-lib
> to get pc-speaker working properly.
> And  even 1.0.16 is not modern enough
> for that. :(
> But that's not a big deal.
> The attached config is only what's
> needed. Put it into /usr/share/alsa/cards
> and /etc/alsa/cards and maybe that
> will help. There should be already
> the file with that name - overwrite it.
>   
With the supplied conf (and without the module option) artsd does not crash
anymore (no sound from pc speaker but that's not an issue, my alsa-lib is
still 1.0.16).
>> Passing -D dsp1 to artsd avoids the crash,
>>     
> The easiest solution is
> ---
> options snd-pcsp index=2
> ---
> into /etc/modprobe.conf. It will
> then not go ahead of 2 other drivers
> of yours.
>   
I can confirm that this solved any issue I had with sound, which is now
working properly.

Kind regards,
R
