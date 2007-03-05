Return-Path: <linux-kernel-owner+w=401wt.eu-S932281AbXCEKVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281AbXCEKVK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 05:21:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932313AbXCEKVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 05:21:09 -0500
Received: from smtp.osdl.org ([65.172.181.24]:40046 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932281AbXCEKVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 05:21:07 -0500
Date: Mon, 5 Mar 2007 02:17:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Marc St-Jean <stjeanma@pmc-sierra.com>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: [PATCH] drivers: PMC MSP71xx TWI driver
Message-Id: <20070305021744.bb34a7ce.akpm@linux-foundation.org>
In-Reply-To: <200702262348.l1QNm6LY015085@pasqua.pmc-sierra.bc.ca>
References: <200702262348.l1QNm6LY015085@pasqua.pmc-sierra.bc.ca>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Previous comments apply - please convert all this code to kernel coding style.

There are many typecasts of void*, eg:

> +	struct pmcmsp_priv_data *p = (struct pmcmsp_priv_data*)data;

Such casts are unneeded and give an undesirable decrease in typesafety - please
remove them all.

pmcmsp_priv_data.lock should be converted from semaphore to a mutex

Convert u_intN_t -> uN throughout.

Convert all symbol of the form getClockConfig to (in this case)
get_clock_config.

These:

> +/* The default settings */
> +const static struct pmctwi_clockcfg pmctwi_defclockcfg = {
> +	.standard = {
> +		.filter = 0x3,
> +		.clock = 0x1f,
> +	},
> +	.highspeed = {
> +		.filter = 0x3,
> +		.clock = 0x1f,
> +	},
> +};
> +
> +const static struct pmctwi_cfg pmctwi_deftwicfg = {
> +	.arbf		= 0x03,
> +	.nak		= 0x03,
> +	.add10		= 0x00,
> +	.mst_code	= 0x00,
> +	.arb		= 0x01,
> +	.highspeed	= 0x00,
> +};

Should be in a .c file, not a .h file.
