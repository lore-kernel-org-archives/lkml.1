Return-Path: <linux-kernel-owner+w=401wt.eu-S1753797AbYLEUch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbYLEUch (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 15:32:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757261AbYLEUcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 15:32:24 -0500
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:57748 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660AbYLEUcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 15:32:23 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 69.181.40.92
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19oNjlVmLNMweA5y0t/gcbT
Date: Fri, 5 Dec 2008 12:32:18 -0800
From: Tony Lindgren <tony@atomide.com>
To: Trilok Soni <soni.trilok@gmail.com>
Cc: samuel@sortiz.org, linux-kernel@vger.kernel.org,
       irda-users@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>, linux-omap@vger.kernel.org
Subject: Re: [irda-users] [PATCH] OMAP IrDA driver
Message-ID: <20081205203216.GJ9714@atomide.com>
References: <5d5443650812042234y6301148at6658f4855500b105@mail.gmail.com> <ea9ea93a42eaf41cd9ee3ff11ad1a026@localhost> <5d5443650812050148n2b3fca72m272a1af33629c478@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d5443650812050148n2b3fca72m272a1af33629c478@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Just one comment below.

* Trilok Soni <soni.trilok@gmail.com> [081205 01:48]:
> Hi Samuel,
> 
> On Fri, Dec 5, 2008 at 2:58 PM,  <samuel@sortiz.org> wrote:
> >
> > Hi,
> >
> > On Fri, 5 Dec 2008 12:04:29 +0530, "Trilok Soni" <soni.trilok@gmail.com>
> > wrote:
> >> This time adding LKML too.
> > Could you please inline the patch so that we can have an easier review ?
> 
> I don't have proper git-send-email integration with gmail, so I am
> going to copy/paste this patch here:

<snip>

> diff --git a/drivers/net/irda/omap-ir.c b/drivers/net/irda/omap-ir.c
> new file mode 100644
> index 0000000..bf29585
> --- /dev/null
> +++ b/drivers/net/irda/omap-ir.c
> @@ -0,0 +1,893 @@

<snip>

> +
> +/*
> + * Set the IrDA communications speed.
> + * Interrupt have to be disabled here.
> + */
> +static int omap_irda_startup(struct net_device *dev)
> +{
> +	struct omap_irda *omap_ir = netdev_priv(dev);
> +
> +	/* FIXME: use clk_* apis for UART3 clock*/
> +	/* Enable UART3 clock and set UART3 to IrDA mode */
> +	if (machine_is_omap_h2() || machine_is_omap_h3())
> +		omap_writel(omap_readl(MOD_CONF_CTRL_0) | (1 << 31) | (1 << 15),
> +				MOD_CONF_CTRL_0);
> +
> +	/* Only for H2?
> +	 */
> +	if (omap_ir->pdata->transceiver_mode && machine_is_omap_h2()) {
> +		/* Is it select_irda on H2 ? */
> +		omap_writel(omap_readl(FUNC_MUX_CTRL_A) | 7,
> +					FUNC_MUX_CTRL_A);
> +		omap_ir->pdata->transceiver_mode(omap_ir->dev, IR_SIRMODE);
> +	}
> +

It would be best to get rid of the machine_is this or that code in the
drivers, and pass the necessary flags in the platform_data.

Regards,

Tony
