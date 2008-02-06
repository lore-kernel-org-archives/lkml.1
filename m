Return-Path: <linux-kernel-owner+w=401wt.eu-S1762593AbYBFLQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762593AbYBFLQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 06:16:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbYBFLQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 06:16:12 -0500
Received: from styx.suse.cz ([82.119.242.94]:39145 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761737AbYBFLQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 06:16:11 -0500
From: David Sterba <dsterba@suse.cz>
To: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH][v4] ipwireless: driver for 3G PC Card
Date: Wed, 6 Feb 2008 12:15:58 +0100
User-Agent: KMail/1.9.6 (enterprise 20071221.751182)
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jkosina@suse.cz, benm@symmetric.co.nz, stephen@symmetric.co.nz
References: <20080201153707.GA24859@ds.suse.cz> <1201883579.15090.14.camel@violet>
In-Reply-To: <1201883579.15090.14.camel@violet>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802061215.58688.dsterba@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > +irqreturn_t ipwireless_interrupt(int irq, void *dev_id, struct pt_regs
> > *regs) +{
> > +	struct ipw_hardware *hw = dev_id;
> > +
> > +	if (hw->hw_version == HW_VERSION_1)
> > +		return ipwireless_handle_v1_interrupt(irq, hw);
> > +	else
> > +		return ipwireless_handle_v2_v3_interrupt(irq, hw);
> > +}
>
> why is this not static? I think the interrupt routine should be in the
> file where you actually claim the interrupt.

This is due to current separation into files. hardware.c has many functions 
for handler bodies, while main.c registers the pcmcia structs in module init 
(and takes address of ipwireless_interrupt()). Long ago, the driver was one 
large file, and I don't want to merge the files back just to make some funcs 
static (and make the sources less readable).

>
> > +/*
> > + * Associate the specified network with this hardware, so it will
> > receive events + * from it.
> > + */
> > +void ipwireless_associate_network(struct ipw_hardware *hw,
> > +				  struct ipw_network *network)
> > +{
> > +	hw->network = network;
> > +}
>
> I think a #define would be simpler in this case.

Same reason, the macro would be used in a file where the struct is not yet 
defined.

> > +module_param(tty_major, int, 0);
> > +module_param_named(debug, ipwireless_debug, int, 0);
> > +module_param_named(loopback, ipwireless_loopback, int, 0);
> > +module_param_named(out_queue, ipwireless_out_queue, int, 0);
> > +MODULE_PARM_DESC(tty_major, "ttyIPWp major number [0]");
>
> Why is allowing to change the major still needed. I think we passed the
> bridge of the need for static numbers a long long long time ago.

Sounds reasonable. I personally haven't used this param (besides testing the 
code) and don't know of any related problems.

> > +static const char drv_name[] = IPWIRELESS_PCCARD_NAME;
>
> This looks useless to. Do we need that?

Removed. Used only in one place.

Thanks for comments. Updated version 5 will follow.

Dave
