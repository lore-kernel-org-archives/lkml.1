Return-Path: <linux-kernel-owner+w=401wt.eu-S1751994AbZK3LpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbZK3LpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 06:45:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751217AbZK3LpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 06:45:11 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42212 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751205AbZK3LpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 06:45:10 -0500
Date: Mon, 30 Nov 2009 11:45:15 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Eduardo Valentin <eduardo.valentin@nokia.com>
Cc: "Hogander Jouni (Nokia-D/Tampere)" <jouni.hogander@nokia.com>,
       "De-Schrijver Peter (Nokia-D/Helsinki)" 
	<Peter.De-Schrijver@nokia.com>,
       "Keski-Saari Juha.1 (EXT-Teleca/Helsinki)" 
	<ext-juha.1.keski-saari@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>, lrg@slimlogic.co.uk
Subject: Re: Doubt about Regulator Framework and VBAT use case
Message-ID: <20091130114515.GB10968@rakim.wolfsonmicro.main>
References: <20091130104102.GA16608@esdhcp037198.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091130104102.GA16608@esdhcp037198.research.nokia.com>
X-Cookie: DYSLEXICS OF THE WORLD, UNTIE!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 12:41:02PM +0200, Eduardo Valentin wrote:

> I'm writing to ask about VBAT use case. What is the expected
> way to use regulator framework in case of rail coming from battery?
> Should it be added to the regulator framework at all?

...

> However, drivers for devices on that rail would require their regulator anyway.
> And I guess the point would be that drivers should not be aware that they are on VBAT
> or any other rail.

I'd add it as a fixed voltage regulator and either not specify the
voltage or specify the nominal voltage.

> - Should drivers fail nicely if a regulator_get fail? And continue even if one fails.
> - Should drivers disable regfw usage completely in the driver if regulator_get doesn't
> give valid regulator ?

These are reasonable approaches if the supply is an optional one that
the device does not need - the driver shouldn't be failing if it doesn't
need to.

> - or Should a fake fixed regulator be added for vbat so drivers can still get a valid
> regulator with regulator_get.

That's the way to do it, yes.

> The last options seams to be the one that does not require much changes on drivers.
> But it will be adding a regulator that does basically nothing in the system.

It's not quite doing nothing, it's mapping out the supply on the board.
Otherwise there's no good way to tell the difference between a supply
not being available because the regulator failed to initialise and the
supply not being available because it's provided by some other invisible 
means.

If the regulator API starts getting a lot of usage on boards that have
primarily fixed regulators we may want to have some support in the core
for automatically faking up supplies if requested by the board but
there's not been much demand for that yet and there's risks.
