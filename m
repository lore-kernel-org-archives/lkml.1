Return-Path: <linux-kernel-owner+w=401wt.eu-S1755096AbZJUUl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbZJUUl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 16:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754874AbZJUUl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 16:41:58 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:37365 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819AbZJUUl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 16:41:57 -0400
Date: Wed, 21 Oct 2009 22:41:58 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Constantin Baranov <const@mimas.ru>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: Re: [PATCH] leds-alix2: add support for button connected to J15
Message-ID: <20091021204158.GN14091@buzzloop.caiaq.de>
References: <20091016130315.GT28832@buzzloop.caiaq.de>
 <20091018072738.GF3935@core.coreip.homeip.net>
 <20091019073728.GC28832@buzzloop.caiaq.de>
 <20091020013852.GC24370@core.coreip.homeip.net>
 <20091020101357.GR28832@buzzloop.caiaq.de>
 <20091021043553.GA378@core.coreip.homeip.net>
 <20091021193347.GL14091@buzzloop.caiaq.de>
 <20091022012121.5b35ff22.const@mimas.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091022012121.5b35ff22.const@mimas.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 22, 2009 at 01:21:21AM +0500, Constantin Baranov wrote:
> I wonder why do you integrate the input driver into the leds driver. They
> should be separated. Or at least the complex driver should be moved to the
> "X86 Platform Specific Device Drivers" and renamed to some like "PC Engines
> ALIX Extras". I personally would prefer the separation way.

I would as well, yes. And I was of course considerating this when I
hacked these lines. However, the major part of the LED driver and what
it currently shares with the button implementation is the BIOS detection
code which is so ugly that I didn't want to duplicate it ;) That would,
however, be the only option if you wanted to split the drivers up. Or
do you have any better idea?

> Also ALIX.2 documentation describes the "Mode switch" driven by GPIO which is a
> small button on front side of a board. I guessed your driver is not for this
> button. If so, would it be better to provide the mode switch as KEY_PROG1 and
> the J15 connected button as KEY_PROG2 at once?

Correct, the button this code is for is not the one on the 'front' side
of the PCB. The other one I didn't try yet, but according the the
CS5536A datasheet, the alternate function for that pin is WORK_AUX which
can be used for power switching purposes. So that might need some extra
care probably.

However, if you can make any suggestion of how to split the code without
copying more than half of the lines for that, I'd be happy with that as
well, of course :)

Daniel
