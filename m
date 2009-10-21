Return-Path: <linux-kernel-owner+w=401wt.eu-S1755563AbZJUVja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbZJUVja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 17:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755008AbZJUVj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 17:39:29 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:61602 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856AbZJUVj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 17:39:29 -0400
Date: Thu, 22 Oct 2009 02:39:28 +0500
From: Constantin Baranov <const@mimas.ru>
To: Daniel Mack <daniel@caiaq.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: Re: [PATCH] leds-alix2: add support for button connected to J15
Message-Id: <20091022023928.2a8afea8.const@mimas.ru>
In-Reply-To: <20091021204158.GN14091@buzzloop.caiaq.de>
References: <20091016130315.GT28832@buzzloop.caiaq.de>
	<20091018072738.GF3935@core.coreip.homeip.net>
	<20091019073728.GC28832@buzzloop.caiaq.de>
	<20091020013852.GC24370@core.coreip.homeip.net>
	<20091020101357.GR28832@buzzloop.caiaq.de>
	<20091021043553.GA378@core.coreip.homeip.net>
	<20091021193347.GL14091@buzzloop.caiaq.de>
	<20091022012121.5b35ff22.const@mimas.ru>
	<20091021204158.GN14091@buzzloop.caiaq.de>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Oct 2009 22:41:58 +0200 Daniel Mack <daniel@caiaq.de> wrote:
> On Thu, Oct 22, 2009 at 01:21:21AM +0500, Constantin Baranov wrote:
> > I wonder why do you integrate the input driver into the leds driver. They
> > should be separated. Or at least the complex driver should be moved to the
> > "X86 Platform Specific Device Drivers" and renamed to some like "PC Engines
> > ALIX Extras". I personally would prefer the separation way.
> 
> I would as well, yes. And I was of course considerating this when I
> hacked these lines. However, the major part of the LED driver and what
> it currently shares with the button implementation is the BIOS detection
> code which is so ugly that I didn't want to duplicate it ;) That would,
> however, be the only option if you wanted to split the drivers up. Or
> do you have any better idea?

We may introduce new ALIX2 extended platform (module in arch/x86/kernel).
In the init function it shall perform detection. The module shall export
the is_alix2() function which shall be called from init functions of drivers.
Also the cs5535_gpio driver could be reused for gpio access (the previous
patch for leds-alix2 is copy&paste from cs5535_gpio).

> > Also ALIX.2 documentation describes the "Mode switch" driven by GPIO which is a
> > small button on front side of a board. I guessed your driver is not for this
> > button. If so, would it be better to provide the mode switch as KEY_PROG1 and
> > the J15 connected button as KEY_PROG2 at once?
> 
> Correct, the button this code is for is not the one on the 'front' side
> of the PCB. The other one I didn't try yet, but according the the
> CS5536A datasheet, the alternate function for that pin is WORK_AUX which
> can be used for power switching purposes. So that might need some extra
> care probably.

Is there an ALIX board which uses that pin for something but button?
The driver ensures that it works with ALIX, not any CS5536.

Constantin
