Return-Path: <linux-kernel-owner+w=401wt.eu-S1759205AbXJaPGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759205AbXJaPGb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 11:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757276AbXJaPGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 11:06:24 -0400
Received: from kukmak.uni-mb.si ([164.8.100.3]:58419 "EHLO kukmak.uni-mb.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757275AbXJaPGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 11:06:24 -0400
Date: Wed, 31 Oct 2007 16:06:19 +0100
From: Domen Puncer <domen.puncer@telargo.com>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: FEC_MPC52xx_MDIO oddness.
Message-ID: <20071031150619.GO3369@nd47.coderock.org>
References: <20071031142212.GA792@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071031142212.GA792@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/10/07 10:22 -0400, Dave Jones wrote:
> The Kconfig for this reads..
> 
> +config FEC_MPC52xx_MDIO
> +       bool "MPC52xx FEC MDIO bus driver"
> +       depends on FEC_MPC52xx
> +       default y
> +       ---help---
> +         The MPC5200's FEC can connect to the Ethernet either with
> +         an external MII PHY chip or 10 Mbps 7-wire interface
> +         (Motorola? industry standard).
> +         If your board uses an external PHY connected to FEC, enable this.
> +         If not sure, enable.
> +         If compiled as module, it will be called 'fec_mpc52xx_phy.ko'.
> 
> Because this is bool, it'll never be compiled as a module.
> Given that fec_mpc52xx_phy.c has a MODULE_LICENSE()
> Should this be a tristate perhaps ?

It's ok, it will be compiled as module if fec driver is compiled as
module, and built-in if fec is built-in.

from Makefile:
obj-$(CONFIG_FEC_MPC52xx) += fec_mpc52xx.o
ifeq ($(CONFIG_FEC_MPC52xx_MDIO),y)
        obj-$(CONFIG_FEC_MPC52xx) += fec_mpc52xx_phy.o
endif

Yes, a bit weird, but it's best I could come up with.
(fec_mdio=m and fec=y is an invalid case, that I wanted to avoid).


	Domen

> 
> 	Dave
> 
> -- 
> http://www.codemonkey.org.uk

-- 
Domen Puncer | Research & Development
.............................................................................................
Telargo d.o.o. | Zagrebška cesta 20 | 2000 Maribor | Slovenia
.............................................................................................
www.telargo.com
