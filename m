Return-Path: <linux-kernel-owner+w=401wt.eu-S1755174AbZFHLky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbZFHLky (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 07:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754713AbZFHLkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 07:40:47 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:6535 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620AbZFHLkq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 07:40:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=fytySqvNgaM7MShVie1uy2luTO4tKqGCPFDe+fDWe8POiPglxZMknT4nSogn2Sa+f9
         h0LWeQMkm/iOBCD0oituI6z/MYXG2xovj9+SiZ2dkjtbPPan/2z+QdO1PCoepP98Z7TJ
         ERe2H4QY/T8lmqKr+T1wayuCEYRhWOSaEwzd8=
From: Florian Fainelli <florian@openwrt.org>
To: Suraj Iyer <ssiyer@ti.com>
Subject: Re: [PATCH 2/9] add support for the TI VLYNQ bus
Date: Mon, 8 Jun 2009 13:40:43 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200906011358.28359.florian@openwrt.org> <loom.20090608T110141-763@post.gmane.org>
In-Reply-To: <loom.20090608T110141-763@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906081340.44529.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suraj,

Le Monday 08 June 2009 13:28:28 Suraj Iyer, vous avez écrit :
> Florian Fainelli <florian <at> openwrt.org> writes:
> > This patch adds support for the TI VLYNQ high-speed,
> > serial and packetized bus. This bus allows external
> > devices to be connected to the System-on-Chip and
> > appear in the main system memory just like any memory
> > mapped peripheral. It is widely used in TI's networking
> > and mutlimedia SoC, including the AR7 SoC.
>
> In addition, the VLYNQ connectivity can also enable usage of one or more
> simultaneous functionitilies (such as WLAN, Ethernet or other peripherals)
> of o one SoC on another. In this sense, a single VLYNQ bus interface
> supports multifunctional devices or multiple peripherals and not just one
> peripheral or device.
>
> > ...
> > ...
> >
> > +
> > +int vlynq_set_local_mapping(struct vlynq_device *dev, u32 tx_offset,
> > +			    struct vlynq_mapping *mapping)
> > +{
> > +	int i;
> > +
> > +	if (!dev->enabled)
> > +		return -ENXIO;
> > +
> > +	vlynq_reg_write(dev->local->tx_offset, tx_offset);
> > +	for (i = 0; i < 4; i++) {
> > +		vlynq_reg_write(dev->local->rx_mapping[i].offset,
> > +							mapping[i].offset);
> > +		vlynq_reg_write(dev->local->rx_mapping[i].size,
> > +							mapping[i].size);
> > +	}
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(vlynq_set_local_mapping);
> > +
> > +int vlynq_set_remote_mapping(struct vlynq_device *dev, u32 tx_offset,
> > +			     struct vlynq_mapping *mapping)
> > +{
> > +	int i;
> > +
> > +	if (!dev->enabled)
> > +		return -ENXIO;
> > +
> > +	vlynq_reg_write(dev->remote->tx_offset, tx_offset);
> > +	for (i = 0; i < 4; i++) {
> > +		vlynq_reg_write(dev->remote->rx_mapping[i].offset,
> > +							mapping[i].offset);
> > +		vlynq_reg_write(dev->remote->rx_mapping[i].size,
> > +							mapping[i].size);
> > +	}
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(vlynq_set_remote_mapping);
> > +
>
> It seems that the current VLYNQ patch assumes that there is just one
> funcitonality or functional device (vlynq_device) that is attached with the
> VLYNQ. It will help to separate out the configuration of VLYNQ (through
> vlynq_set_local_mapping / vlynq_set_remote_mapping) from the
> functionalities (i.e. vlynq_device) that can be supported over VLYNQ. Once,
> the functional devices / drivers are isolated from the SoC specific VLYNQ
> configurations, the drivers can be independently re-used across multiple
> VLYNQ based SoC(s).

The device that allowed writing this VLYNQ implementation is a TI AR7 SoC, to 
which only a WLAN device is attached afaik, therefore we did not handled all 
the VLYNQ topology cases. If you want to submit an incremental patch that 
enhances the current implementation I will be glad to test and review it.

>
> Some of the other potential benefits, down the line, arising out of the
> stated isolation would be the discovery & auto-configuration of VLYNQ
> SoC(s), construction of daisy-chain and derive enumerated values (such as
> base addresses and interrupt numbers) required by the peripheral or
> functional drivers.
>
> Specifically, the VLYNQ (SoC) configuration is platform specific and
> functional drivers (vlynq_device & vlynq_driver) should not be attached to
> it.
>
> Thanks,
> Suraj
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Best regards, Florian Fainelli
Email : florian@openwrt.org
http://openwrt.org
-------------------------------
