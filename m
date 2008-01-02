Return-Path: <linux-kernel-owner+w=401wt.eu-S1757855AbYABWex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757855AbYABWex (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 17:34:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754284AbYABWeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 17:34:44 -0500
Received: from ozlabs.org ([203.10.76.45]:32771 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754483AbYABWen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 17:34:43 -0500
Date: Wed, 2 Jan 2008 22:20:30 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Jochen Friedrich <jochen@scram.de>
Cc: linuxppc-dev@ozlabs.org, Scott Wood <scottwood@freescale.com>,
       linux-kernel@vger.kernel.org,
       "linuxppc-embedded@ozlabs.org" <linuxppc-embedded@ozlabs.org>
Subject: Re: [PATCHv3] powerpc: DBox2 Board Support
Message-ID: <20080102112030.GB23168@localhost.localdomain>
Mail-Followup-To: Jochen Friedrich <jochen@scram.de>,
	linuxppc-dev@ozlabs.org, Scott Wood <scottwood@freescale.com>,
	linux-kernel@vger.kernel.org,
	"linuxppc-embedded@ozlabs.org" <linuxppc-embedded@ozlabs.org>
References: <477522DB.4000100@scram.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <477522DB.4000100@scram.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2007 at 05:22:51PM +0100, Jochen Friedrich wrote:
> This patch adds device tree source, default config and setup code for
> DBox2 devices.

[snip]
> +++ b/arch/powerpc/boot/dts/dbox2.dts
> @@ -0,0 +1,251 @@
> +/*
> + * DBOX2 Device Tree Source
> + *
> + * Copyright 2007 Jochen Friedrich <jochen@scram.de>
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +/ {
> +	model = "unknown,dbox2"; // boot wrapper fills in correct manufacturer

Probably better just to leave model out of the dts and let the
bootwrapper add it.

[snip]
> +		cam@3,0 {
> +			compatible = "betaresearch,dbox2-cam";
> +			reg = <3 0 20000 6 0 20000>;
> +			interrupts = <6 2>;
> +			interrupt-parent = <&PIC>;
> +			gpios = <1 1c 1 1d 1 1e 1 1f>;
> +			gpio-parent = <&CPM1_PIO>;
> +		};
> +
> +		mpegdec@4,0 {

The established generic names don't generally use abbreviations.  So I
would suggest "mpeg-decoder" here instead.

> +			compatible = "c-cube,avia";
> +			reg = <4 0 200>;
> +			interrupts = <8 2>;
> +			interrupt-parent = <&PIC>;
> +		};
> +
> +		mpegdemux@5,0 {

Likewise "mpeg-demultiplexer"

> +			compatible = "c-cube,enx";
> +			reg = <5 0 3400 7 0 200000>;
> +			interrupts = <2 2>;
> +			interrupt-parent = <&PIC>;
> +		};
> +
> +		flash@0,0 {
> +			compatible = "cfi-flash";
> +			reg = <0 0 800000>;
> +			bank-width = <4>;
> +			device-width = <1>;
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			partition@0 {
> +				label = "BR bootloader";
> +				reg = <0 20000>;
> +				read-only;
> +			};
> +			partition@20000 {
> +				label = "FLFS (U-Boot)";
> +				reg = <20000 20000>;
> +			};
> +			partition@40000 {
> +				label = "rootfs";
> +				reg = <40000 7c0000>;
> +			};
> +			ovpartition@20000 {

Uh.. I really don't know what the MTD driver will handle these
overlapping partitions.  I suspect it will not be pretty...

> +				label = "Flash without bootloader";
> +				reg = <20000 7e0000>;
> +			};
> +			ovpartition@0 {
> +				label = "Complete Flash";
> +				reg = <0 800000>;
> +				read-only;
> +			};
> +		};
> +	};

[snip]
> +	chosen {
> +		linux,stdout-path = "/soc/cpm/serial@a80";

Probably worth using a path reference here, now they're implemented.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
