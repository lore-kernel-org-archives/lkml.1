Return-Path: <linux-kernel-owner+w=401wt.eu-S1755650AbXJJRHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650AbXJJRHa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 13:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755443AbXJJRHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 13:07:19 -0400
Received: from nijmegen.renzel.net ([195.243.213.130]:53572 "EHLO
	nijmegen.renzel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429AbXJJRHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 13:07:16 -0400
X-Greylist: delayed 819 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Oct 2007 13:07:16 EDT
Message-ID: <470D0373.1030308@linuxtv.org>
Date: Wed, 10 Oct 2007 18:53:07 +0200
From: Marcel Siegert <mws@linuxtv.org>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>, video4linux-list@redhat.com,
       Jiri Slaby <jirislaby@gmail.com>, daniel@qanu.de,
       linux-kernel@vger.kernel.org, holger@qanu.de,
       Alan Cox <alan@redhat.com>,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [v4l-dvb-maintainer] [PATCH 3/3] V4L: cinergyT2, remove bad	usage
 of ERESTARTSYS
References: <24841282012868130110@pripojeni.net>	<1191979260.5492.32.camel@gaivota>	<470C5294.8060502@linuxtv.org>	<1192030541.5896.54.camel@gaivota>	<20071010155920.GC22618@devserv.devel.redhat.com>	<1192033070.5896.77.camel@gaivota> <470D0087.3050606@gmail.com>
In-Reply-To: <470D0087.3050606@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Manu Abraham schrieb:
> Mauro Carvalho Chehab wrote:
>> Em Qua, 2007-10-10 Ã s 11:59 -0400, Alan Cox escreveu:
>>> On Wed, Oct 10, 2007 at 12:35:41PM -0300, Mauro Carvalho Chehab wrote:
>>>> Em Qua, 2007-10-10 Ã s 00:18 -0400, Michael Krufky escreveu:
>>>>> Is this illegal as per kernel codingstyle?
>>>> Yes, it is. CodingStyle states:
>>> <rant>
>>> No.. "Illegal" means prohibited by law. Its merely wrong 8)
>>> </rant>
>> LOL
>>
>>>> The proper fix is just to replace the offended code by this:
>>>>
>>>> err=foo();
>>>> if (error)
>>>> 	goto error;
>>> Lots of code uses
>>>
>>> 	if ((err = foo()) < 0)
>>>
>>> so I would'y worry too much. The split one however clearer and also
>>> safer.
>> Yes, this is not a severe CodingStyle violation. Still, the above code
>> is better than the used one.
>>
>> Since, on your example, it is clear that the programmer wanted to test
>> if the value is less than zero. 
>>
>> The code:
>>
>> 	if ( (err=foo()) )
>>
>> should also indicate an operator mistake of using =, instead of ==.
>>
>> Probably, source code analyzers like Coverity will complain about the
>> above.
>>
>> If not violating CodingStyle, I would rather prefer to code this as:
>> 	if ( !(err=foo() ) 
>> or, even better, using:
>> 	if ( (err=foo()) != 0)
>>
>> clearly indicating that it is tested if the value is not zero.
>>
>> Even being a quite simple issue, I would prefer if Jiri can fix it.
>>
> 
> 
> When you have only some few lines of code you can write
> 
>  err = foo()
>  if (err) {
>   do whatever
>  } 
> 
> doesn't matter ..
> 
> But when you have hell a lot of code, checking error's what you 
> mention is insane.
> 
> ie,
> 
> if ((err = foo()) expr ) is better.
> 
> http://lkml.org/lkml/2007/2/4/56
> 
> Manu
> 
hi manu,

it's not worth discussing this in a way like
"i know something from the past and that was a different solution".

if you look to other parts in that thread like

http://lkml.org/lkml/2007/2/3/150

you will see that they came also to a kind of different solution,
NOT to use the 1-liner for assignment statements.

it's more like a religious/personal discussion how to 
struct/indent/format code.
and, to state my position for clear,

if kernel coding style document isnt updated to allow the constructions
of code that caused this discussion, we dont have to discuss but follow 
the rules.

anything else on this topic (coding style and it's sense) is to be 
discussed on kernel ml.

my 2ct
marcel



> _______________________________________________
> v4l-dvb-maintainer mailing list
> v4l-dvb-maintainer@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/v4l-dvb-maintainer

