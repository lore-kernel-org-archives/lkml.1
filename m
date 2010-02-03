Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328Ab0BCJZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 04:25:10 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46867 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756618Ab0BCJZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 04:25:04 -0500
Date: Wed, 3 Feb 2010 09:24:53 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Amit Kucheria <amit.kucheria@canonical.com>
Cc: List Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.infradead.org, s.hauer@pengutronix.de,
       valentin.longchamp@epfl.ch, daniel@caiaq.de, grant.likely@secretlab.ca,
       Dinh.Nguyen@freescale.com, r.herring@freescale.com,
       bryan.wu@canonical.com
Subject: Re: [PATCHv2 05/11] mxc: Core support for i.MX5 series of
	processors from Freescale
Message-ID: <20100203092453.GA21921@n2100.arm.linux.org.uk>
References: <cover.1265173480.git.amit.kucheria@canonical.com> <f10f79e7313ecdeeb59ab881795baedf2430c636.1265173480.git.amit.kucheria@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f10f79e7313ecdeeb59ab881795baedf2430c636.1265173480.git.amit.kucheria@canonical.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 02, 2010 at 09:16:27PM -0800, Amit Kucheria wrote:
> +static int _clk_pll_set_rate(struct clk *clk, unsigned long rate)
> +{
> +	u32 reg;
> +	void __iomem *pllbase;
> +
> +	long mfi, pdf, mfn, mfd = 999999;
> +	s64 temp64;
> +	unsigned long quad_parent_rate;
> +	unsigned long pll_hfsm, dp_ctl;
> +	unsigned long parent_rate;
> +
> +	parent_rate = clk_get_rate(clk->parent);
> +
> +	pllbase = _get_pll_base(clk);
> +
> +	quad_parent_rate = 4 * parent_rate;
> +	pdf = mfi = -1;
> +	while (++pdf < 16 && mfi < 5)
> +		mfi = rate * (pdf+1) / quad_parent_rate;
> +	if (mfi > 15)
> +		return -1;

Why not "return -EPERM" since what you're actually saying here by
returning -1 is "Permission Denied"?  If you didn't mean "Permission
Denied", then don't use return -1.
