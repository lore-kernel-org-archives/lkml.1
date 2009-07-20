Return-Path: <linux-kernel-owner+w=401wt.eu-S1753305AbZGTTAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbZGTTAh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 15:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbZGTTAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 15:00:35 -0400
Received: from ru.mvista.com ([213.79.90.228]:34152 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750780AbZGTTAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 15:00:35 -0400
Date: Mon, 20 Jul 2009 23:00:34 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Ian Molton <spyro@f2s.com>, Anton Vorontsov <cbou@mail.ru>,
       Matt Reimer <mreimer@vpop.net>
Subject: Re: [PATCH 1/3] pda-power: add set_charged functionaltity
Message-ID: <20090720190034.GA24617@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <1247759044-4747-1-git-send-email-daniel@caiaq.de>
 <20090720182752.GA20602@oksana.dev.rtsoft.ru>
 <20090720183711.GF19257@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090720183711.GF19257@buzzloop.caiaq.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 08:37:11PM +0200, Daniel Mack wrote:
> On Mon, Jul 20, 2009 at 10:27:52PM +0400, Anton Vorontsov wrote:
> > On Thu, Jul 16, 2009 at 05:44:02PM +0200, Daniel Mack wrote:
> > > This adds a function to let the power supply core know that the battery
> > > is fully charged now. This can be done by watching a GPIO line, for
> > > example.
> > > 
> > > Some battery drivers might need that information to calibrate
> > > themselves.
> > > 
> > > Signed-off-by: Daniel Mack <daniel@caiaq.de>
> > > Cc: Ian Molton <spyro@f2s.com>
> > > Cc: Anton Vorontsov <cbou@mail.ru>
> > > Cc: Matt Reimer <mreimer@vpop.net>
> > > ---
> > >  drivers/power/power_supply_core.c |   16 ++++++++++++++++
> > >  include/linux/power_supply.h      |    3 +++
> > 
> > The patch is missing pda_power.c part?
> 
> Erm, does it? What would you expect it to do in there?

Um... then the patch subject is misleading. It says "pda-power".

Is there any user of this new call, btw? I mean a mainline user,
or soon to be?

> > >  #if defined(CONFIG_POWER_SUPPLY) || defined(CONFIG_POWER_SUPPLY_MODULE)
> > >  extern int power_supply_is_system_supplied(void);
> > > +extern void power_supply_set_battery_charged(void);
> > 
> > I don't quite like this interface. Note that system might want
> > to know if it's supplied (hence global is_system_supplied(void) call),
> > but having set_battery_charged(void) interface makes little sense
> > (well, it makes sense for small embedded systems that have just
> > one battery and one charger)...
> > 
> > There is a supplied_to psy field that might help you there...
> 
> Hmm. I thought about that too, but didn't find a way to access the
> single members of the pda-power device and find the right one to
> access. They're registered on a string base and matched magically once
> the battery monitor is probed when found on the one-wire bus. Any
> proposal how an interface could look like that does that?
> 
> All I need is a way to pass this information from my platform code down
> to the battery driver.

Yes, I see the problem, but I don't have a solution off-hand. :-/

Let me think about it for awhile.

> > The cleanup patch looks OK though, I'll apply it.
> 
> Thanks. What about the one adding support for the bootstrapping of the
> current_accum value? I've sent that inline as a reply to the other patch
> series (4/4) last week (which was probably not a good idea).

"ds2760: add current_accum module parameter"? Looks perfectly OK.

Thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
