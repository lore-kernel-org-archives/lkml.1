Return-Path: <linux-kernel-owner+w=401wt.eu-S936793AbYD1Vaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936793AbYD1Vaa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 17:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932721AbYD1VaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 17:30:09 -0400
Received: from mail.hauppauge.com ([167.206.143.4]:4040 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933679AbYD1VaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 17:30:07 -0400
Message-ID: <481641CD.5030202@linuxtv.org>
From: mkrufky@linuxtv.org
To: mchehab@infradead.org
Cc: bunk@kernel.org, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [patch] dvb: build failure fix
Date: Mon, 28 Apr 2008 17:29:49 -0400
MIME-Version: 1.0
X-Mailer: Internet Mail Service (5.5.2657.72)
in-reply-to: <20080428182501.5bb87058@gaivota>
x-originalarrivaltime: 28 Apr 2008 21:26:43.0374 (UTC) FILETIME=[8E013CE0:01C8A976]
user-agent: Thunderbird 2.0.0.12 (Windows/20080213)
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro Carvalho Chehab wrote:
> On Tue, 29 Apr 2008 00:01:22 +0300
> Adrian Bunk <bunk@kernel.org> wrote:
>
>   
>> On Mon, Apr 28, 2008 at 09:53:30PM +0200, Ingo Molnar wrote:
>>     
>>> * Adrian Bunk <bunk@kernel.org> wrote:
>>>
>>>       
>>>> On Mon, Apr 28, 2008 at 06:24:21PM +0200, Ingo Molnar wrote:
>>>>         
>>>>> fix build failure found via x86.git randconfig testing:
>>>>>
>>>>>  drivers/built-in.o: In function `tda829x_attach':
>>>>>  : undefined reference to `tda827x_attach'
>>>>>  drivers/built-in.o: In function `tda829x_attach':
>>>>>  : undefined reference to `tda18271_attach'
>>>>>
>>>>> build failure is due to this nasty dependency:
>>>>>
>>>>>   CONFIG_DVB_CORE=m but CONFIG_TUNER_TDA8290=y.
>>>>>           
>>>> It might work around the problem in your specific configuration, but 
>>>> it's not the correct solution.
>>>>
>>>> Please send your .config .
>>>>         
>>> i dont have it anymore,
>>>       
>> That's bad since it makes it harder for other people to reproduce the 
>> problem.
>>
>>     
>>> but the key was what i wrote in the changelog 
>>> above:
>>>
>>>   CONFIG_DVB_CORE=m
>>>   CONFIG_TUNER_TDA8290=y
>>>
>>> if you look at the symbols above, their definition sites, and the 
>>> dependencies between them you'll see why that breaks the build. (There 
>>> might be more to it, this area has been a frequent source of problems.)
>>>       
>> TUNER_TDA8290 is the only affected driver, your patch also adds wrong 
>> dependences to other driver.
>>
>> And the underlying problem is that it has both an analog an a DVB tuner, 
>> and although forcing a dependency on DVB_CORE might make the randconfig 
>> crowd happy it's not the correct solution.
>>
>> Mauro, where were we regarding this issue?
>>
>> What about:
>>
>> config TUNER_TDA8290
>>         tristate "TDA 8290/8295 + 8275(a)/18271 tuner combo"
>>         depends on I2C
>> 	depends on DVB_CORE || DVB_CORE=n
>>         select DVB_TDA827X if DVB_CORE
>>         select DVB_TDA18271 if DVB_CORE
>>         default m if VIDEO_TUNER_CUSTOMIZE
>>         help
>>           Say Y here to include support for Philips TDA8290+8275(a)
tuner.
>>
>> Or is there some twist I'm missing?
>>     
>
>
> This will fix compilation, but some drivers will be broken, since tda8275
is
> needed even for some analog-only drivers.
>
> It would be better to do a "select DVB_CORE", although this is also ugly.
>
> I'm pinging Mkrufky. He is the one that touched a lot on those drivers.
Maybe
> he can come up with a better solution.

The fix for this issue will come "for free" after the tuner location 
reorganization to the media/common/ folder.

If you try the devel branch of mauro's v4l-dvb tree, is the issue 
resolved for you?

Regards,

Mike
