Return-Path: <linux-kernel-owner+w=401wt.eu-S1753229AbZFYENj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbZFYENj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 00:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750753AbZFYENb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 00:13:31 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:46768 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbZFYENa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 00:13:30 -0400
Date: Thu, 25 Jun 2009 13:12:28 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Baruch Siach <baruch@tkos.co.il>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ben Dooks <ben-linux@fluff.org>
Subject: Re: linux-next: origin tree build failure
Message-ID: <20090625041228.GD13668@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Baruch Siach <baruch@tkos.co.il>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Linus <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Ben Dooks <ben-linux@fluff.org>
References: <20090625111344.35febd82.sfr@canb.auug.org.au> <20090625032407.GO6027@tarshish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090625032407.GO6027@tarshish>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 06:24:08AM +0300, Baruch Siach wrote:
> Hi Stephen,
> 
> On Thu, Jun 25, 2009 at 11:13:44AM +1000, Stephen Rothwell wrote:
> > Today's linux-next build (x86_64 allmodconfig) failed like this:
> > 
> > ERROR: "clk_enable" [drivers/i2c/busses/i2c-designware.ko] undefined!
> > ERROR: "clk_disable" [drivers/i2c/busses/i2c-designware.ko] undefined!
> > ERROR: "clk_put" [drivers/i2c/busses/i2c-designware.ko] undefined!
> > ERROR: "clk_get_rate" [drivers/i2c/busses/i2c-designware.ko] undefined!
> > ERROR: "clk_get" [drivers/i2c/busses/i2c-designware.ko] undefined!
> > 
> > Caused by commit 1ab52cf910bbbee92861227e6ed77c56b1dc233c ("i2c: driver
> > for the Synopsys DesignWare I2C controller") from Linus' tree which I
> > have reverted for today.
> 
> So, what is the right configuration symbol to depend on for the clk API?
> 
CONFIG_HAVE_CLK.

> A short archives search led to the "provide a dummy implementation of the clk 
> API" patch from Uwe Kleine-K?nig 
> (http://lkml.indiana.edu/hypermail/linux/kernel/0804.2/2748.html). Is this the 
> right solution?
> 
Something like this would be better handled in include/linux/clk.h.

One of the things to watch out for is clk_get_rate(), there are
cases in the kernel where the rate is fetched with clk_get_rate() and
then subsequently used as a divisor in some other equation.
clk_get_rate() probably ought to WARN_ON(1) unconditionally, as any
driver wanting rate information is going to need proper clock
information.
