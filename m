Return-Path: <linux-kernel-owner+w=401wt.eu-S1755643AbZLDKiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643AbZLDKiI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 05:38:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753775AbZLDKiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 05:38:07 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60181 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbZLDKiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 05:38:06 -0500
Date: Fri, 4 Dec 2009 10:38:04 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Amit Kucheria <amit.kucheria@canonical.com>
Cc: List Linux Kernel <linux-kernel@vger.kernel.org>,
       Dinh.Nguyen@freescale.com, s.hauer@pengutronix.de,
       grant.likely@secretlab.ca, r.herring@freescale.com,
       linux-arm-kernel@lists.infradead.org, daniel@caiaq.de,
       valentin.longchamp@epfl.ch
Subject: Re: [RFC][PATCH 01/10] arm: mxc: New interrupt controller (TZIC)
	for i.MX5 family
Message-ID: <20091204103804.GB15887@n2100.arm.linux.org.uk>
References: <cover.1259893118.git.amit.kucheria@canonical.com> <e99e70e2a619693064130a747b6ee3a93273337b.1259893118.git.amit.kucheria@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e99e70e2a619693064130a747b6ee3a93273337b.1259893118.git.amit.kucheria@canonical.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few comments:

On Fri, Dec 04, 2009 at 04:47:01AM +0200, Amit Kucheria wrote:
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/init.h>
> +#include <linux/device.h>
> +#include <linux/errno.h>
> +#include <mach/hardware.h>
> +#include <linux/io.h>

linux/ includes all together please.

> +void __iomem *tzic_base;

static?

> +
> +/*!

This isn't kerneldoc standard.

> +static int mxc_set_wake_irq(unsigned int irq, unsigned int enable)
> +{
> +	unsigned int index, off;
> +
> +	index = irq >> 5;
> +	off = irq & 0x1F;
> +
> +	if (index > 3)
> +		return -1;

Never use -1 as an error code.  -1 is bad.  Look up in
asm-generic/errno-base.h to see what error code 1 means.

Please chose a far better error code.  Same goes for any other uses
of '-1' in this kind of context.

> +	printk(KERN_INFO "MXC IRQ initialized\n");

MXC or TZIC?
