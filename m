Return-Path: <linux-kernel-owner+w=401wt.eu-S935772AbYBHBie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935772AbYBHBie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 20:38:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935666AbYBHBiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 20:38:09 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:2146 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932651AbYBHBiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 20:38:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=xugjgGdXccBcxMARYGZrfABr3nCZK5+IXU3aaKCTI0opErCYVoy6R5zGkbrZoAgx1M/uAXbX8zQCK07Ce4PSMjtpDVJ3GwBSYT55hWDFuNFFAEygordl3b9yKUEFuuUdO6vtLkbdvbduwzDole3m83QhG4+XkhM4CYWeywcFxPo=
Message-ID: <2c0942db0802071738g2f426d4y6ee9ab58b62d8174@mail.gmail.com>
Date: Thu, 7 Feb 2008 17:38:01 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Carlos Corbacho" <carlos@strangeworlds.co.uk>
Subject: Re: ACPI_WMI: worst config description of all times
Cc: "Pavel Machek" <pavel@ucw.cz>, "Len Brown" <lenb@kernel.org>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.osdl.org>,
       linux-acpi@vger.kernel.org
In-Reply-To: <200802080119.08872.carlos@strangeworlds.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080207214715.GA15211@elf.ucw.cz>
	 <200802072351.32521.carlos@strangeworlds.co.uk>
	 <2c0942db0802071612r1b32f996jc26ac3792b8c31fc@mail.gmail.com>
	 <200802080119.08872.carlos@strangeworlds.co.uk>
X-Google-Sender-Auth: d6b91ea3845ff0fd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 7, 2008 5:19 PM, Carlos Corbacho <carlos@strangeworlds.co.uk> wrote:
> On Friday 08 February 2008 00:12:24 Ray Lee wrote:
> > On Feb 7, 2008 3:51 PM, Carlos Corbacho <carlos@strangeworlds.co.uk> wrote:
> > > On Thursday 07 February 2008 23:33:54 Ray Lee wrote:
> > > > Do you have list of hardware/platforms that require this feature to
> > > > get the hardware to work? (acer abc123, tcm1100 xyz)
> > >
> > > I have a very long list of Acer laptops that are supported - which is far
> > > too long, and changes on far too much of a regular basis to put in there.
> > >
> > > Perhaps adding something like "This driver is also a required dependency
> > > to build the firmware specific drivers needed for many laptops, including
> > > Acer and HP machines"?
>
> Would this be acceptable then?
>
> -Carlos
> ---
> ACPI: WMI: Improve Kconfig entry
>
> From: Carlos Corbacho <carlos@strangeworlds.co.uk>
>
> As Pavel Machek has pointed out, the Kconfig entry for WMI is pretty
> non-descriptive.
>
> Rewrite it so that it explains what ACPI-WMI is, and why anyone
> would want to enable it.
>
> Many thanks to Ray Lee for ideas on this.
>
> Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
> CC: Pavel Machek <pavel@ucw.cz>
> CC: Ray Lee <ray-lk@madrabbit.org>
> CC: Len Brown <lenb@kernel.org>
> ---
>
>  drivers/acpi/Kconfig |   19 +++++++++++++++----
>  1 files changed, 15 insertions(+), 4 deletions(-)
>
>
> diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
> index b7fbf16..ea763ef 100644
> --- a/drivers/acpi/Kconfig
> +++ b/drivers/acpi/Kconfig
> @@ -207,11 +207,22 @@ config ACPI_WMI
>         depends on EXPERIMENTAL
>         depends on X86
>         help
> -         This driver adds support for the ACPI-WMI mapper device (PNP0C14)
> -         found on some systems.
> +         This driver adds support for the ACPI-WMI (Windows Management
> +         Instrumentation) mapper device (PNP0C14) found on some systems.
>
> -         NOTE: You will need another driver or userspace application on top of
> -         this to actually use anything defined in the ACPI-WMI mapper.
> +         ACPI-WMI is a proprietary extension to ACPI to expose parts of the
> +         ACPI firmware to userspace - this is done through various vendor
> +         defined methods and data blocks in a PNP0C14 device, which are then
> +         made available for userspace to call.
> +
> +         The implementation of this in Linux currently only exposes this to
> +         other kernel space drivers.
> +
> +         This driver is a required dependency to build the firmware specific
> +         drivers needed on many machines, including Acer and HP laptops.
> +
> +         It is safe to enable this driver even if your DSDT doesn't define
> +         any ACPI-WMI devices.
>
>  config ACPI_ASUS
>          tristate "ASUS/Medion Laptop Extras"
>

<nod> That's clear to me (whereas the original wasn't), though I would
still argue for this driver being select'ed by the drivers that
require it. As you note, other laptop specific drivers do so, and
Linus has come down in favor of that as well in the past, so you have
a friend in high places :-).
