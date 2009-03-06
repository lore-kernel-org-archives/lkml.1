Return-Path: <linux-kernel-owner+w=401wt.eu-S1756364AbZCFSbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364AbZCFSbJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 13:31:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbZCFSaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 13:30:55 -0500
Received: from rv-out-0506.google.com ([209.85.198.230]:24211 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbZCFSaz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 13:30:55 -0500
MIME-Version: 1.0
In-Reply-To: <E1LfeFk-0002mD-OE@zelda.netsplit.com>
References: <E1LfeFk-0002mD-OE@zelda.netsplit.com>
Date: Fri, 6 Mar 2009 19:30:52 +0100
Message-ID: <ac3eb2510903061030j339578dfi116ae729f43604d1@mail.gmail.com>
Subject: Re: [PATCH] floppy: Provide a PNP device table in the module.
From: Kay Sievers <kay.sievers@vrfy.org>
To: Scott James Remnant <scott@canonical.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 6, 2009 at 18:50, Scott James Remnant <scott@canonical.com> wrote:
> The missing device table means that the floppy module is not
> auto-loaded, even when the appropriate PNP device (0700) is found.
>
> We don't actually use the table in the module, since the device doesn't
> have a struct pnp_driver, but it's sufficient to cause an alias in the
> module that udev/modprobe will use.
>
> Signed-off-by: Scott James Remnant <scott@canonical.com>
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
>  drivers/block/floppy.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
> index 83d8ed3..7aa1264 100644
> --- a/drivers/block/floppy.c
> +++ b/drivers/block/floppy.c
> @@ -177,6 +177,7 @@ static int print_unex = 1;
>  #include <linux/interrupt.h>
>  #include <linux/init.h>
>  #include <linux/platform_device.h>
> +#include <linux/mod_devicetable.h>
>  #include <linux/buffer_head.h> /* for invalidate_buffers() */
>  #include <linux/mutex.h>
>
> @@ -4598,6 +4599,13 @@ MODULE_AUTHOR("Alain L. Knaff");
>  MODULE_SUPPORTED_DEVICE("fd");
>  MODULE_LICENSE("GPL");
>
> +/* This doesn't actually get used other than for module information */
> +static const struct pnp_device_id floppy_pnpids[] = {
> +       { "PNP0700", 0 },
> +       { }
> +};
> +MODULE_DEVICE_TABLE(pnp, floppy_pnpids);
> +

Looks good to me. Thanks for doing that.

Acked-by: Kay Sievers <kay.sievers@vrfy.org>

Kay
