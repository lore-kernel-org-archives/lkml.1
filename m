Return-Path: <linux-kernel-owner+w=401wt.eu-S1754394AbZG2L6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394AbZG2L6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 07:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754326AbZG2L6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 07:58:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57216 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754304AbZG2L6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 07:58:19 -0400
Date: Wed, 29 Jul 2009 12:58:17 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Ian Molton <ian@mnementh.co.uk>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>,
       Magnus Damm <damm@opensource.se>
Subject: Re: MMC: Make the configuration memory resource optional
Message-ID: <20090729115817.GA12223@rakim.wolfsonmicro.main>
References: <Pine.LNX.4.64.0907170842050.4731@axis700.grange>
 <4A6F033B.7030302@mnementh.co.uk>
 <aec7e5c30907281948s2a0dcd0csd3e580251d6c4f5a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aec7e5c30907281948s2a0dcd0csd3e580251d6c4f5a@mail.gmail.com>
X-Cookie: Turn off engine while fueling.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 11:48:51AM +0900, Magnus Damm wrote:

> I understand that you want to have clocklib so you can manage clocks
> dynamically for your mfd drivers, but in our use case we already have
> working clock framework implementations withing our SoC. There is no
> need for any dynamic clock registration and unregistration. With that
> in mind it can't be very difficult to understand that there is no
> point for SoC vendors to work on clocklib. If's mainly an issue for
> mfd.

While it's true that this doesn't bother SoCs the fact that most clock
API implementations don't allow any off-chip drivers to register clocks
renders the clock API essentially unusable for fairly large parts of the
kernel.  This is especially problematic where the clocks cross from
the SoC domain to the off-SoC domain and clocks from each domain may be
used interchangably.

Looking at the original patch I'm not sure exactly why it runs into
clock API issues so I'm not sure if this is a relevant concern or not
here but I'm mentioning it since I'd kind of expect an impact on the
SoCs from addressing it due to the way the clock API functions are
currently provided.
