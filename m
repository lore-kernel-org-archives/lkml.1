Return-Path: <linux-kernel-owner+w=401wt.eu-S933490AbYBHHiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933490AbYBHHiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 02:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756718AbYBHHiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 02:38:14 -0500
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:50230 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758226AbYBHHiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 02:38:14 -0500
X-Greylist: delayed 2076 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Feb 2008 02:38:13 EST
Message-ID: <47ABFEC5.8010206@freemail.hu>
Date: Fri, 08 Feb 2008 08:03:33 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Richard Purdie <rpurdie@rpsys.net>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] LED updates
References: <1202380503.9519.21.camel@dax.rpnet.com>	 <20080207213845.GA27862@khazad-dum.debian.net> <1202422388.9519.123.camel@dax.rpnet.com>
In-Reply-To: <1202422388.9519.123.camel@dax.rpnet.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Purdie wrote:
> On Thu, 2008-02-07 at 19:38 -0200, Henrique de Moraes Holschuh wrote:
>> On Thu, 07 Feb 2008, Richard Purdie wrote:
>>> Márton Németh:
>>>       leds: Add support for hardware accelerated LED flashing
>>>       leds: hw acceleration for Clevo mail LED driver
>> This one has a loose end: when you call brightness_set on a led with
>> hardware flash acceleration, you will leave the trigger armed, BUT the led
>> won't blink anymore.  That's just wrong.
> 
> Agreed.

My only question is that do you know any LED hardware which can blink _and_
can set the brightness independently? If there would be such a LED I could
imagine that the brightness can be changed while the LED remains blinking at
some low frequency. For example a simple LED with brightness set possibility and
blinking directed by software is an example where the blinking and the brightness
setting are completely independent.

I agree, however, that if the brightness is set to LED_OFF, the trigger
should be also removed.

>> Either we should always remove *any* (hardware accelerated or not!) active
>> trigger when a write to brightness_set is done, or the stuff about "calling
>> brightness_set will disable the hardware accelerated blink" has to go.
>>
>> I personally prefer that we would always remove any active trigger if
>> brightness_set is to be called.  IMHO, it is neater, and it is also the
>> least-surprise-behaviour from an user perspective with the LED_OFF:LED_FULL
>> triggers we have right now.
> 
> Even without the hardware acceleration, a user write to set_brightness
> leaves any active trigger active and isn't really intuitive or right
> either. 
> 
>> Which one will be?  If it is "remove any active trigger", I'd not mind
>> writing the patch.

