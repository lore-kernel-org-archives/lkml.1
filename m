Return-Path: <linux-kernel-owner+w=401wt.eu-S1761587AbYBGVkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761587AbYBGVkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:40:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964870AbYBGVi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 16:38:56 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:56417 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964858AbYBGViy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 16:38:54 -0500
X-Sasl-enc: A7kzf6DNHyZrVY5u+Lb0W81gLf9S8HN/mCnB4hvCWNBn 1202420333
Date: Thu, 7 Feb 2008 19:38:45 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Richard Purdie <rpurdie@rpsys.net>,
       =?iso-8859-1?Q?M=E1rton_N=E9meth?= <nm127@freemail.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] LED updates
Message-ID: <20080207213845.GA27862@khazad-dum.debian.net>
References: <1202380503.9519.21.camel@dax.rpnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1202380503.9519.21.camel@dax.rpnet.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Feb 2008, Richard Purdie wrote:
> Márton Németh:
>       leds: Add support for hardware accelerated LED flashing
>       leds: hw acceleration for Clevo mail LED driver

This one has a loose end: when you call brightness_set on a led with
hardware flash acceleration, you will leave the trigger armed, BUT the led
won't blink anymore.  That's just wrong.

Either we should always remove *any* (hardware accelerated or not!) active
trigger when a write to brightness_set is done, or the stuff about "calling
brightness_set will disable the hardware accelerated blink" has to go.

I personally prefer that we would always remove any active trigger if
brightness_set is to be called.  IMHO, it is neater, and it is also the
least-surprise-behaviour from an user perspective with the LED_OFF:LED_FULL
triggers we have right now.

Which one will be?  If it is "remove any active trigger", I'd not mind
writing the patch.

> Richard Purdie:
>       leds: Standardise LED naming scheme

This one causes trouble (at least on 2.6.23 -- I backported the patch) due
to the 20-byte length limit on sysfs names.  I had to use "tp::<somecrap>"
instead of "thinkpad::<somecrap>" to name LEDs, and still had to reduce
ultrabase_battery to ultrabase_batt :-)

Anyway, IMHO, the LED function should come first, and we should not even
need the led driver name anywhere.  In case of clashes in the class sysfs
dir, just tack a .# to the end or somesuch.  The device the LED is tied to
already differentiates them.  That would save a lot of chars for something
much more useful (the function).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
