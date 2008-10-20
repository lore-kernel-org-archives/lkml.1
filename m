Return-Path: <linux-kernel-owner+w=401wt.eu-S1752452AbYJTPsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452AbYJTPsq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 11:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbYJTPsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 11:48:38 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:24100 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751246AbYJTPsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 11:48:37 -0400
Date: Mon, 20 Oct 2008 19:48:35 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       "Steven A. Falco" <sfalco@harris.com>,
       Grant Likely <grant.likely@secretlab.ca>,
       Jean Delvare <khali@linux-fr.org>, David Miller <davem@davemloft.net>,
       i2c@lm-sensors.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 4/7] gpiolib: implement dev_gpiochip_{add,remove} calls
Message-ID: <20081020154835.GA3234@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20081016171222.GA24812@oksana.dev.rtsoft.ru> <200810171324.42650.david-b@pacbell.net> <20081017212942.GA1919@oksana.dev.rtsoft.ru> <200810200029.58312.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <200810200029.58312.david-b@pacbell.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 12:29:57AM -0700, David Brownell wrote:
[...]
> > Anyway most of them need some modifications to work with OF...
> 
> The changes I saw were just to cope with not having
> the system-specific platform_data provided:  don't
> fail if that pointer is NULL, and arrange for dynamic
> allocation of some GPIO numbers.
> 
> With OpenFirmware, presumably the implication is that
> the relevant data is in the OF device tree...

Yes. Some data is in the device tree.

> I think that it *barely* makes sense to allow the chips
> to bind to drivers without platform data when there's
> not even OF in the environment. ONLY in the case where
> the GPIOs are exported through sysfs, in fact, since
> otherwise there's no way for other system components
> to know those GPIOs even exist!!  And even that seems
> pretty marginal to me...

Platform data is a completely different story. And yes, we can't
handle it properly with the device tree. By "properly" I mean without
adding an explicit OF stuff to the drivers, i.e. we should handle the
pdata transparently to the existing drivers.

I quite like the bus notifiers approach:

http://lkml.org/lkml/2008/6/5/209  (mmc_spi example)

But it doesn't work as a module (i.e. OF-specific bits should be
always in-kernel).

[...]
> > If you don't like it, I can readily implement hooks for
> > gpiochip_{add,remove}().
> 
> It seems a better way to a clean solution, IMO.

Ok. I will do it.

[...]
> Did you look at providing chip-aware OF glue drivers
> for this stuff?  Doing stuff like just turn the OF
> device properties into the right platform_data, and
> maybe runing FORTH bytecodes to do other configuration
> magic needed...

Yes. Few times already. To make the glue, every driver needs
some modifications, and it is always triggers huge discussions
about how to exactly refactor the driver to make it work with
the OF.

http://lkml.org/lkml/2008/5/23/297 (again mmc_spi example).

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
