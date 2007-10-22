Return-Path: <linux-kernel-owner+w=401wt.eu-S1753981AbXJVLlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbXJVLlc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 07:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbXJVLlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 07:41:25 -0400
Received: from host06.hostingexpert.com ([216.80.70.60]:59862 "EHLO
	host06.hostingexpert.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbXJVLlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 07:41:24 -0400
Message-ID: <471C8C5E.1070901@linuxtv.org>
Date: Mon, 22 Oct 2007 07:41:18 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Trent Piepho <xyzzy@speakeasy.org>
CC: Adrian Bunk <bunk@kernel.org>, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [v4l-dvb-maintainer] [2.6 patch] fix CONFIG_TUNER_TEA5761=m
References: <20071022024755.GJ30533@stusta.de> <471C19F1.8090505@linuxtv.org> <Pine.LNX.4.58.0710212201060.16052@shell4.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0710212201060.16052@shell4.speakeasy.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host06.hostingexpert.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - linuxtv.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trent Piepho wrote:
> On Sun, 21 Oct 2007, Michael Krufky wrote:
>   
>> Adrian Bunk wrote:
>>     
>>> This patch fixes CONFIG_TUNER_TEA5761=m broken by
>>> commit ca805d57cf5ea7482ed3da28653f30621249ee45.
>>>
>>> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>>>
>>> ---
>>>
>>>  drivers/media/video/tuner-core.c |    6 ------
>>>  1 file changed, 6 deletions(-)
>>>
>>> 26336c30e76c37bda368a24b8b12978388a18cf3
>>> diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
>>> index 9484308..1795b78 100644
>>> --- a/drivers/media/video/tuner-core.c
>>> +++ b/drivers/media/video/tuner-core.c
>>> @@ -30,9 +30,7 @@
>>>
>>>  /* standard i2c insmod options */
>>>  static unsigned short normal_i2c[] = {
>>> -#ifdef CONFIG_TUNER_TEA5761
>>>  	0x10,
>>> -#endif
>>>
>>>       
>> ^^^ I believe that we want to keep these #ifdef's above...  The removals
>> below are fine.
>>     
>
> Won't leaving in the call to tea5761_autodetection() when tea5761 is not
> compiled in result in an undefined symbol error?
>   
It shouldn't -- See tea5761.h ... If the module is not selected, then a
stub will report that the driver was disabled by Kconfig.
> I think what we want to do put in the typical if(TEA5761 >= TUNER) include tea5761
> code in tuner logic that the rest of the selectable sub-driver use.
>
> #if defined(CONFIG_TUNER_TEA5761) || (defined(CONFIG_TUNER_TEA5761_MODULE) && defined(MODULE))
>   
This is what I have in my tree here...  ^^^ Isn't this already upstream
by now?

-Mike
