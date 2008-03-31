Return-Path: <linux-kernel-owner+w=401wt.eu-S1758751AbYCaOza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751AbYCaOza (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750872AbYCaOzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:55:18 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:35441 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbYCaOzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:55:17 -0400
Date: Mon, 31 Mar 2008 16:55:16 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, tony@atomide.com,
       paul@pwsan.com
Subject: Re: [PATCH 1/6] Clocklib: add generic framework for managing clocks.
Message-ID: <20080331145515.GA10969@atrey.karlin.mff.cuni.cz>
References: <20080331083947.GA11282@doriath.ww600.siemens.net> <20080331084420.GA11617@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080331084420.GA11617@doriath.ww600.siemens.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +int __must_check clk_register(struct clk *clk);
> +void clk_unregister(struct clk *clk);
> +static void __maybe_unused clks_unregister(struct clk **clks, size_t num)
> +{
> +	int i;
> +	for (i = num - 1; i >= 0;  i++) {
> +		clk_unregister(clks[i]);
> +	}
> +}
> +
> +static int __must_check __maybe_unused clks_register(struct clk **clks, size_t num)
> +{
> +	int i;
> +	int ret;
> +	for (i = 0; i < num; i++) {
> +		ret = clk_register(clks[i]);
> +		if (ret != 0)
> +			goto cleanup;
> +	}
> +
> +	return 0;
> +
> +cleanup:
> +	clks_unregister(clks, i);
> +
> +	for (i -- ; i >= 0; i--) {

"for (i--;"
> +		clk_unregister(clks[i]);
> +	}
> +
> +	return ret;

Hmm, clk_unregister is _very_ similar to clks_unregister....
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
