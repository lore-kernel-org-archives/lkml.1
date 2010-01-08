Return-Path: <linux-kernel-owner+w=401wt.eu-S1752293Ab0AHBjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293Ab0AHBjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 20:39:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082Ab0AHBjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 20:39:13 -0500
Received: from mail.perches.com ([173.55.12.10]:1642 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970Ab0AHBjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 20:39:12 -0500
Subject: Re: [PATCH] drivers/net/defxx.c: use %pMF to show MAC address
From: Joe Perches <joe@perches.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       macro@linux-mips.org, davem@davemloft.net
In-Reply-To: <201001071624.20139.hartleys@visionengravers.com>
References: <201001071624.20139.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jan 2010 17:39:10 -0800
Message-ID: <1262914750.10429.88.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-07 at 16:24 -0700, H Hartley Sweeten wrote:
> Use the %pMF kernel extension to display the MAC address.
> The address will still be displayed in the FDDI Canonical format.

> diff --git a/drivers/net/defxx.c b/drivers/net/defxx.c
> index 6a6ea03..e4eac4b 100644
> --- a/drivers/net/defxx.c
> +++ b/drivers/net/defxx.c
> @@ -1052,12 +1052,9 @@ static int __devinit dfx_driver_init(struct net_device *dev,
>  		board_name = "DEFEA";
>  	if (dfx_bus_pci)
>  		board_name = "DEFPA";
> -	pr_info("%s: %s at %saddr = 0x%llx, IRQ = %d, "
> -		"Hardware addr = %02X-%02X-%02X-%02X-%02X-%02X\n",
> +	pr_info("%s: %s at %saddr = 0x%llx, IRQ = %d, Hardware addr = %pMF\n",
>  		print_name, board_name, dfx_use_mmio ? "" : "I/O ",

I believe the output will _now_ be in the canonical form.
Before it wasn't bit reversed.  Now it should be.

