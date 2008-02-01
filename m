Return-Path: <linux-kernel-owner+w=401wt.eu-S1758914AbYBAQc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758914AbYBAQc5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 11:32:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755359AbYBAQct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 11:32:49 -0500
Received: from senator.holtmann.net ([87.106.208.187]:38092 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253AbYBAQcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 11:32:48 -0500
Subject: Re: [PATCH][v4] ipwireless: driver for 3G PC Card
From: Marcel Holtmann <marcel@holtmann.org>
To: dsterba@suse.cz
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jkosina@suse.cz, benm@symmetric.co.nz, stephen@symmetric.co.nz
In-Reply-To: <20080201153707.GA24859@ds.suse.cz>
References: <20080201153707.GA24859@ds.suse.cz>
Content-Type: text/plain
Date: Fri, 01 Feb 2008 17:32:59 +0100
Message-Id: <1201883579.15090.14.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

> +irqreturn_t ipwireless_interrupt(int irq, void *dev_id, struct pt_regs *regs)
> +{
> +	struct ipw_hardware *hw = dev_id;
> +
> +	if (hw->hw_version == HW_VERSION_1)
> +		return ipwireless_handle_v1_interrupt(irq, hw);
> +	else
> +		return ipwireless_handle_v2_v3_interrupt(irq, hw);
> +}

why is this not static? I think the interrupt routine should be in the
file where you actually claim the interrupt.

> +/*
> + * Associate the specified network with this hardware, so it will receive events
> + * from it.
> + */
> +void ipwireless_associate_network(struct ipw_hardware *hw,
> +				  struct ipw_network *network)
> +{
> +	hw->network = network;
> +}

I think a #define would be simpler in this case.

> +module_param(tty_major, int, 0);
> +module_param_named(debug, ipwireless_debug, int, 0);
> +module_param_named(loopback, ipwireless_loopback, int, 0);
> +module_param_named(out_queue, ipwireless_out_queue, int, 0);
> +MODULE_PARM_DESC(tty_major, "ttyIPWp major number [0]");

Why is allowing to change the major still needed. I think we passed the
bridge of the need for static numbers a long long long time ago.

> +static const char drv_name[] = IPWIRELESS_PCCARD_NAME;

This looks useless to. Do we need that?

Regards

Marcel


