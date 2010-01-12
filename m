Return-Path: <linux-kernel-owner+w=401wt.eu-S1754300Ab0ALQZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab0ALQZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 11:25:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754282Ab0ALQZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 11:25:48 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45683 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260Ab0ALQZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 11:25:47 -0500
Date: Tue, 12 Jan 2010 16:25:39 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linuxppc-dev@lists.ozlabs.org
Subject: Re: [RFC,PATCH 3/7 v2] arm/versatile: use generic struct clk
Message-ID: <20100112162539.GH27771@n2100.arm.linux.org.uk>
References: <1263279511.160127.576969496193.0.gpush@pororo> <1263279511.161193.484965724912.3.gpush@pororo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263279511.161193.484965724912.3.gpush@pororo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 05:58:31PM +1100, Jeremy Kerr wrote:
> diff --git a/arch/arm/common/clkdev.c b/arch/arm/common/clkdev.c
> index aae5bc0..71e7596 100644
> --- a/arch/arm/common/clkdev.c
> +++ b/arch/arm/common/clkdev.c
> @@ -85,11 +85,13 @@ struct clk *clk_get(struct device *dev, const char *con_id)
>  }
>  EXPORT_SYMBOL(clk_get);
>  
> +#ifndef CONFIG_USE_COMMON_STRUCT_CLK
>  void clk_put(struct clk *clk)
>  {
>  	__clk_put(clk);
>  }
>  EXPORT_SYMBOL(clk_put);
> +#endif /* CONFIG_USE_COMMON_STRUCT_CLK */

This doesn't make any sense.  What are you trying to do here?

The get/put operations go together as one logical set - that's why you
get both if you're using clkdev, and why you're asked to implement both
__clk_get() and __clk_put() in arch code to do whatever's necessary
with the clock.

Let me guess, and say that clk_put() is not a release method.  It's a
method for drivers to say "I'm done with this clock" and for the arch
code to reverse the effects of __clk_get()/clk_get().

Currently, its only user is to balance module counts.
