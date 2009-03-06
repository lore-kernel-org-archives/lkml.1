Return-Path: <linux-kernel-owner+w=401wt.eu-S1756153AbZCFXtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbZCFXtm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 18:49:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320AbZCFXtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 18:49:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43005 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752983AbZCFXtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 18:49:32 -0500
Date: Fri, 6 Mar 2009 15:48:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Scott James Remnant <scott@canonical.com>
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Philippe De Muyter <phdm@macqel.be>, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] floppy: Provide a PNP device table in the module.
Message-Id: <20090306154852.8354fe52.akpm@linux-foundation.org>
In-Reply-To: <E1LfeFk-0002mD-OE@zelda.netsplit.com>
References: <E1LfeFk-0002mD-OE@zelda.netsplit.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Mar 2009 17:50:47 +0000
Scott James Remnant <scott@canonical.com> wrote:

> The missing device table means that the floppy module is not
> auto-loaded, even when the appropriate PNP device (0700) is found.

Is this a regression?  Did 2.6.28 autoload OK?

> We don't actually use the table in the module, since the device doesn't
> have a struct pnp_driver, but it's sufficient to cause an alias in the
> module that udev/modprobe will use.
> 
> Signed-off-by: Scott James Remnant <scott@canonical.com>
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
>  drivers/block/floppy.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
> index 83d8ed3..7aa1264 100644
> --- a/drivers/block/floppy.c
> +++ b/drivers/block/floppy.c
> @@ -177,6 +177,7 @@ static int print_unex = 1;
>  #include <linux/interrupt.h>
>  #include <linux/init.h>
>  #include <linux/platform_device.h>
> +#include <linux/mod_devicetable.h>
>  #include <linux/buffer_head.h>	/* for invalidate_buffers() */
>  #include <linux/mutex.h>
>  
> @@ -4598,6 +4599,13 @@ MODULE_AUTHOR("Alain L. Knaff");
>  MODULE_SUPPORTED_DEVICE("fd");
>  MODULE_LICENSE("GPL");
>  
> +/* This doesn't actually get used other than for module information */
> +static const struct pnp_device_id floppy_pnpids[] = {
> +	{ "PNP0700", 0 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(pnp, floppy_pnpids);
> +
>  #else
>  
>  __setup("floppy=", floppy_setup);

Either way, this looks like 2.6.29 stuff.
