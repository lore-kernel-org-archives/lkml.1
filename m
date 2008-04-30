Return-Path: <linux-kernel-owner+w=401wt.eu-S932450AbYD3Tc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450AbYD3Tc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 15:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763986AbYD3TcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 15:32:12 -0400
Received: from mail.hauppauge.com ([167.206.143.4]:2628 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763644AbYD3TcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 15:32:10 -0400
Message-ID: <4818C91E.8070307@linuxtv.org>
From: mkrufky@linuxtv.org
To: bunk@kernel.org
Cc: mchehab@infradead.org, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [patch] dvb: build failure fix
Date: Wed, 30 Apr 2008 15:31:42 -0400
MIME-Version: 1.0
X-Mailer: Internet Mail Service (5.5.2657.72)
in-reply-to: <20080430192829.GF29330@cs181133002.pp.htv.fi>
x-originalarrivaltime: 30 Apr 2008 19:28:33.0538 (UTC) FILETIME=[60F59E20:01C8AAF8]
user-agent: Thunderbird 2.0.0.12 (Windows/20080213)
Content-Type: text/plain;
	charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Wed, Apr 30, 2008 at 04:17:12PM -0300, Mauro Carvalho Chehab wrote:
>   
>> On Mon, 28 Apr 2008 17:29:49 -0400
>> mkrufky@linuxtv.org wrote:
>>
>>     
>>> Mauro Carvalho Chehab wrote:
>>>       
>>>> On Tue, 29 Apr 2008 00:01:22 +0300
>>>> Adrian Bunk <bunk@kernel.org> wrote:
>>>>         
>> ...
>>     
>>>>> Mauro, where were we regarding this issue?
>>>>>
>>>>> What about:
>>>>>
>>>>> config TUNER_TDA8290
>>>>>         tristate "TDA 8290/8295 + 8275(a)/18271 tuner combo"
>>>>>         depends on I2C
>>>>> 	depends on DVB_CORE || DVB_CORE=n
>>>>>         select DVB_TDA827X if DVB_CORE
>>>>>         select DVB_TDA18271 if DVB_CORE
>>>>>         default m if VIDEO_TUNER_CUSTOMIZE
>>>>>         help
>>>>>           Say Y here to include support for Philips TDA8290+8275(a)
>>>>>           
>>> tuner.
>>>       
>>>>> Or is there some twist I'm missing?
>>>>>     
>>>>>           
>>>> This will fix compilation, but some drivers will be broken, since
tda8275
>>>>         
>>> is
>>>       
>>>> needed even for some analog-only drivers.
>>>>
>>>> It would be better to do a "select DVB_CORE", although this is also
ugly.
>>>>
>>>> I'm pinging Mkrufky. He is the one that touched a lot on those drivers.
>>>>         
>>> Maybe
>>>       
>>>> he can come up with a better solution.
>>>>         
>>> The fix for this issue will come "for free" after the tuner location 
>>> reorganization to the media/common/ folder.
>>>       
>> Yes, but I think we should try do do something for 2.6.25 and 2.6.24.
>>     
>
> Toralf and Ingo only discovered it during randconfig testing.
>
> Are there actually reports from users running into this problem?
>
>   
>> Maybe, we
>> may just do:
>> obj-y += /dvb
>> ...
>>     
>
> Do DVB_TDA827X/DVB_TDA18271 need anything from DVB_CORE?
>
> If yes you'd only transform one build error into another.

DVB_TDA827X and DVB_TDA18271 do not need anything from DVB_CORE -- their 
only dependency is I2C_CORE.

I think Mauro renamed those Kconfig symbols to MEDIA_TUNER_TDAfoo now, btw.

-Mike
