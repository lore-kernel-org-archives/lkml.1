Return-Path: <linux-kernel-owner+w=401wt.eu-S1753315AbZIBSme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbZIBSme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 14:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753259AbZIBSme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 14:42:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41703 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753251AbZIBSmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 14:42:33 -0400
Date: Wed, 2 Sep 2009 19:42:35 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Samuel Ortiz <sameo@linux.intel.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH 2/2] U300 AB3100 boardinfo v3
Message-ID: <20090902184234.GB10581@rakim.wolfsonmicro.main>
References: <1251756324-24216-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251756324-24216-1-git-send-email-linus.walleij@stericsson.com>
X-Cookie: When in doubt, lead trump.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 01, 2009 at 12:05:24AM +0200, Linus Walleij wrote:
> This defines regulator platform data and board power
> regulator hogs for the ST-Ericsson U300 platform.

This is pretty much OK, just...

> +static struct regulator_consumer_supply supply_ldo_a[] = {
> +	{
> +		.dev = NULL,
> +		.supply = "vrad", /* Powers the radio */
> +	},
> +};

Now you're using the regulator init stuff to set the voltages you should
be able to drop most of the deviceless supplies.  I'd expect that you'd
want to keep the CPU core supplies for cpufreq support but the others
shouldn't need to be defined.  The names can be set in the constraints
- if set there they will be displayed to user space which normally makes
the diagnostics easier to follow for board users.
