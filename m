Return-Path: <linux-kernel-owner+w=401wt.eu-S1755057AbZLBUkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbZLBUkX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 15:40:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754188AbZLBUkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 15:40:22 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38007 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753385AbZLBUkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 15:40:21 -0500
Date: Wed, 2 Dec 2009 20:40:26 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: Richard Purdie <rpurdie@rpsys.net>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Daniel Ribeiro <drwyrm@gmail.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, openezx-devel@lists.openezx.org
Subject: Re: [PATCH] leds: Add LED class driver for regulator driven LEDs.
Message-ID: <20091202204026.GA18311@rakim.wolfsonmicro.main>
References: <1259775625-25973-1-git-send-email-ospite@studenti.unina.it>
 <20091202180658.GA12292@rakim.wolfsonmicro.main>
 <20091202212521.500f7a46.ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091202212521.500f7a46.ospite@studenti.unina.it>
X-Cookie: This page intentionally left blank.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 02, 2009 at 09:25:21PM +0100, Antonio Ospite wrote:
> Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> > There's no need to do this since the regulator API matches consumers
> > based on struct device as well as name so you can have as many LEDs as
> > you like all using the same supply name mapping to different regulators.

> I need some more explanation here, I am currently using the driver with
> this code:

> +/* VVIB: Vibrator on A780, A1200, A910, E6, E2 */
> +static struct regulator_consumer_supply pcap_regulator_VVIB_consumers
> [] = {
> +	{ .dev_name = "leds-regulator", .supply = "vibrator", },

So you're instantiating the device with .id set to -1 (as your code
below shows), meaning there's only one leds-regulator in the system and
there's no need to number them.  If you had more than one of them then
you'd number them and then have something like:

	{ .dev_name = "leds-regulator.0", supply = "vled" },
	{ .dev_name = "leds-regulator.1", supply = "vled" },

when setting up the supplies.

> If I set the .supply value fixed, how can I assign different
> regulators to different leds? Should I use the address to the platform
> device (a780_vibrator in this case) for .dev when defining the
> regulator in the first place?

There is no need to use the .dev field, that is kept to avoid build
breakage transitioning to dev_name.
