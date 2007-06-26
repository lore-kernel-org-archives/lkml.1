Return-Path: <linux-kernel-owner+w=401wt.eu-S1755541AbXFZDOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbXFZDOH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 23:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbXFZDN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 23:13:56 -0400
Received: from waste.org ([66.93.16.53]:52436 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbXFZDN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 23:13:56 -0400
Date: Mon, 25 Jun 2007 22:13:41 -0500
From: Matt Mackall <mpm@selenic.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hw_random: add quality categories
Message-ID: <20070626031340.GQ11166@waste.org>
References: <200706241555.22957.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706241555.22957.mb@bu3sch.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2007 at 03:55:22PM +0200, Michael Buesch wrote:
> This adds quality categories for hardware random number generators.
> 
...
> +
> +/**
> + * enum hwrng_quality - Quality identifier for RNG hardware
> + * @HWRNG_QUAL_HIGH:	High quality RNG. Higher quality than
> + * 			what is found on the usual PC mainboards.
> + * 			Use that for special dedicated RNG
> + * 			extension boards.
> + * @HWRNG_QUAL_NORMAL:	PC-onboard-RNG devices.
> + * @HWRNG_QUAL_LOW:	Low quality RNG devices. Use this for
> + * 			devices which gather the entropy from possibly
> + * 			bad sources, like the network.
> + * @HWRNG_QUAL_PSEUDO:	Pseudo RNG device. Use this for devices
> + * 			which are not RNG devices by definition, but
> + * 			could be used as such. For example various
> + * 			hardware sensors, like a motion sensor.
> + */

I don't think these definitions are very useful.

There are basically three ways of measuring RNG quality:

a) does it generate a good spectrum based on an unpredictable physical
process like Schott noise or free-running oscillator beat patterns?

b) can the end-user trust that the design is implemented as described?

c) does it output lots of bits fast?

Anything that fails (a) belongs in the PSEUDO class. This applies to
RNGs where the implementation is undocumented too. (There's not much
excuse for this as it costs negligible silicon to do this right.)

Anything that passes (b) is something that the end-user built
themselves while wearing their tinfoil hat.

Anything that claims to be significantly better than the trivial
circuit and whitening on a typical PC is probably marketing hype. 

Which brings us down to (c). And basically all hardware RNGs are
plenty fast enough.

So that's basically three orthogonal axes: "real", "trusted", and
"fast". And "trusted" trumps "real", which trumps "fast".

-- 
Mathematics is the supreme nostalgia of our time.
