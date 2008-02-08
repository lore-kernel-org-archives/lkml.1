Return-Path: <linux-kernel-owner+w=401wt.eu-S934006AbYBHLVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934006AbYBHLVP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 06:21:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762143AbYBHLUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 06:20:48 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:51867 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762048AbYBHLUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 06:20:46 -0500
X-Sasl-enc: xoY9yrAOcJOJpImDNIOcQzi36L/Pa4LXzTPQXKPPyR7g 1202469645
Date: Fri, 8 Feb 2008 09:20:40 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: =?iso-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: Richard Purdie <rpurdie@rpsys.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] LED updates
Message-ID: <20080208112040.GA9485@khazad-dum.debian.net>
References: <1202380503.9519.21.camel@dax.rpnet.com> <20080207213845.GA27862@khazad-dum.debian.net> <1202422388.9519.123.camel@dax.rpnet.com> <47ABFEC5.8010206@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47ABFEC5.8010206@freemail.hu>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Feb 2008, Németh Márton wrote:
> Richard Purdie wrote:
> >>>       leds: Add support for hardware accelerated LED flashing
> >> This one has a loose end: when you call brightness_set on a led with
> >> hardware flash acceleration, you will leave the trigger armed, BUT the led
> >> won't blink anymore.  That's just wrong.
> > 
> > Agreed.
> 
> My only question is that do you know any LED hardware which can blink _and_
> can set the brightness independently? If there would be such a LED I could

Several, but none on laptops or other stuff that runs Linux.  That behaviour
is not common on indicator LEDs.  I have seen standby LEDs on laptops which
"blink" by slowly fading from full to off, and then back to full, though.

> imagine that the brightness can be changed while the LED remains blinking at
> some low frequency. For example a simple LED with brightness set possibility and
> blinking directed by software is an example where the blinking and the brightness
> setting are completely independent.

Sure, it is perfectly possible.  I am not sure it is *desireable*, though.
The way we have triggers work make what you describe impossible right now,
the software triggers are LED_OFF:LED_FULL, not LED_OFF:old-brightness.

And so are the common hardware triggers on laptops, for that matter.

If we go and fix every trigger to use the current brightness (as long as it
is non-zero) as the "turn LED on" trigger event, then the documentation has
to be changed accordingly to do what you said above, and we would stop the
trigger only by setting brightness to zero or by explicitly removing it.

I don't think it is worth the hassle, though.  But we better decide that
*now*, because all this changing of the LED class ABI (even if it is, IMHO,
a big improvement) is not a good idea.  We better do it all during the
2.6.25 cycle.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
