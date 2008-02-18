Return-Path: <linux-kernel-owner+w=401wt.eu-S1761423AbYBRWte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761423AbYBRWte (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 17:49:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752376AbYBRWt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 17:49:26 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:63973 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750770AbYBRWtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 17:49:25 -0500
Date: Mon, 18 Feb 2008 23:49:18 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: spi-devel-general@lists.sourceforge.net,
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>, linux-kernel@vger.kernel.org
Subject: Re: [spi-devel-general] atmel_spi clock polarity
Message-ID: <20080218234918.3d09022a@siona>
In-Reply-To: <200802181157.57299.david-b@pacbell.net>
References: <20080216.223252.25909396.anemo@mba.ocn.ne.jp>
	<20080218124237.0b5f701c@dhcp-252-066.norway.atmel.com>
	<20080218.231243.41197917.anemo@mba.ocn.ne.jp>
	<200802181157.57299.david-b@pacbell.net>
Organization: Atmel
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Feb 2008 11:57:56 -0800
David Brownell <david-b@pacbell.net> wrote:

> On Monday 18 February 2008, Atsushi Nemoto wrote:
> > 	 IIRC the clock state follows
> > CSRn.CPOL just before the real transfer.
> 
> No ... clock state should be valid *before* chipselect goes
> active.  So I'm thinking the patch from Haavard is likely
> the right change.

Hopefully it is...

> > CLK     ______________________|~|___|~~~|___|~~~|___|~~~|___
> 
> ... and at T1 CPOL is changed??  That's wrong.  There should
> never be a partial clock period while a chipselect is active.
> While it's inactive, sure -- no chip should care.

...but what I'm afraid of is that since we're using GPIO chipselects,
the controller may _think_ that no chip is selected and change the
clock polarity just before it would pull the chipselect low if we were
using automatic chipselects...

If that's the case, it would be a bit strange if it actually helped to
initialize all the CSRn registers, but it would also offer us a nice
workaround...

Atsushi, do you by any chance have debugging enabled? That would
explain the long delay from CS activation to the change of clock
polarity. Compared to printk() the DMA setup takes almost no time at
all.

If you can confirm that my patch helps, I think that's the one we want
in mainline.

Haavard
