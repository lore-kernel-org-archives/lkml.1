Return-Path: <linux-kernel-owner+w=401wt.eu-S1751849AbXLaQuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbXLaQuq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 11:50:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750805AbXLaQui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 11:50:38 -0500
Received: from pip15.gyao.ne.jp ([61.122.117.253]:22583 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750748AbXLaQuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 11:50:08 -0500
Date: Tue, 1 Jan 2008 01:49:59 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrew Murray <amurray@mpc-data.co.uk>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sh: sh7712 clock support
Message-ID: <20071231164959.GA23319@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Andrew Murray <amurray@mpc-data.co.uk>, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <0C997DD87CC88A4F86C897F52650B52B820E8F@MOLSON.mpc-data.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0C997DD87CC88A4F86C897F52650B52B820E8F@MOLSON.mpc-data.co.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 31, 2007 at 04:32:25PM -0000, Andrew Murray wrote:
> +static void bus_clk_init(struct clk *clk)
> +{
> +	clk->rate = CONFIG_SH_PCLK_FREQ;
> +}
> +
> +static struct clk_ops sh7712_bus_clk_ops = {
> +	.init		= bus_clk_init,
> +};
> +
This shouldn't be necessary, the bus clk already references the master
clk as its parent, and inherits the rate from there. If you have no
recalc work to do, then you should be able to just leave this out
altogether. If you actually need this dummy init, then something is
broken with the upper layer, which we should fix ;-)

Patch looks fine otherwise. Tidy this up and I'll apply it.
