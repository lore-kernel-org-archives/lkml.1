Return-Path: <linux-kernel-owner+w=401wt.eu-S1757138AbXGEBek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138AbXGEBek (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 21:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754046AbXGEBef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 21:34:35 -0400
Received: from adsl-67-117-79-109.dsl.sntc01.pacbell.net ([67.117.79.109]:2883
	"EHLO aurum.uhlenkott.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650AbXGEBee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 21:34:34 -0400
X-Greylist: delayed 304 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Jul 2007 21:34:34 EDT
Date: Wed, 4 Jul 2007 18:29:29 -0700
From: Jason Uhlenkott <jasonuhl@jasonuhl.org>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fujtisu application panel driver
Message-ID: <20070705012929.GA4728@aurum.uhlenkott.net>
References: <20070702111724.43ee5b43@freepuppy.localdomain.hemminger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070702111724.43ee5b43@freepuppy.localdomain.hemminger.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2007 at 11:17:24 -0700, Stephen Hemminger wrote:
> +static int __init apanel_init(void)
> +{
> +	void __iomem *bios;
> +	u8 devno;
> +	int found = 0;
> +
> +	if (!dmi_check_system(apanel_dmi_table)) {
> +		printk(KERN_WARNING "apanel: DMI information does not match\n");
> +		if (!force)
> +			return -ENODEV;
> +	}
> +	BUG_ON(!keymap);

If force=1 and there's no DMI match, we're guaranteed to pop this BUG_ON.


> +
> +			device_chip[devno] = (enum apanel_chip) chip;
> +			++found;
> +		}
> +	}
> +	iounmap(bios);

This isn't the address we got from ioremap (although it happens to
work, since iounmap internally masks it against PAGE_MASK).
