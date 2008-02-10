Return-Path: <linux-kernel-owner+w=401wt.eu-S1756967AbYBJLxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967AbYBJLxK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 06:53:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbYBJLw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 06:52:57 -0500
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:64425 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbYBJLw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 06:52:56 -0500
Message-ID: <47AEE57E.9030000@freemail.hu>
Date: Sun, 10 Feb 2008 12:52:30 +0100
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Richard Purdie <rpurdie@rpsys.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] LED updates
References: <1202380503.9519.21.camel@dax.rpnet.com> <20080207213845.GA27862@khazad-dum.debian.net> <1202422388.9519.123.camel@dax.rpnet.com> <47ABFEC5.8010206@freemail.hu> <20080208112040.GA9485@khazad-dum.debian.net>
In-Reply-To: <20080208112040.GA9485@khazad-dum.debian.net>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> On Fri, 08 Feb 2008, Németh Márton wrote:
>> Richard Purdie wrote:
>>>>>       leds: Add support for hardware accelerated LED flashing
>>>> This one has a loose end: when you call brightness_set on a led with
>>>> hardware flash acceleration, you will leave the trigger armed, BUT the led
>>>> won't blink anymore.  That's just wrong.
>>> Agreed.
>> My only question is that do you know any LED hardware which can blink _and_
>> can set the brightness independently? If there would be such a LED I could
> 
> Several, but none on laptops or other stuff that runs Linux.  That behaviour
> is not common on indicator LEDs.  I have seen standby LEDs on laptops which
> "blink" by slowly fading from full to off, and then back to full, though.
> 
>> imagine that the brightness can be changed while the LED remains blinking at
>> some low frequency. For example a simple LED with brightness set possibility and
>> blinking directed by software is an example where the blinking and the brightness
>> setting are completely independent.
> 
> Sure, it is perfectly possible.  I am not sure it is *desireable*, though.
> The way we have triggers work make what you describe impossible right now,
> the software triggers are LED_OFF:LED_FULL, not LED_OFF:old-brightness.
> 
> And so are the common hardware triggers on laptops, for that matter.
> 
> If we go and fix every trigger to use the current brightness (as long as it
> is non-zero) as the "turn LED on" trigger event, then the documentation has
> to be changed accordingly to do what you said above, and we would stop the
> trigger only by setting brightness to zero or by explicitly removing it.
> 
> I don't think it is worth the hassle, though.  But we better decide that
> *now*, because all this changing of the LED class ABI (even if it is, IMHO,
> a big improvement) is not a good idea.  We better do it all during the
> 2.6.25 cycle.

I investigated what would have to be changed if we decide that the
brightness and the blinking parameters can be set independently. There
are not much too change I think, please have a look at my next mail.

	Márton Németh
