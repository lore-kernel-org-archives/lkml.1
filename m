Return-Path: <linux-kernel-owner+w=401wt.eu-S1753170AbZC3HhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbZC3HhP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 03:37:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbZC3Hg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 03:36:59 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:38867 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbZC3Hg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 03:36:58 -0400
Date: Mon, 30 Mar 2009 09:36:41 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: Hans de Goede <hdegoede@redhat.com>, linux-kernel@vger.kernel.org,
       Matthew Garrett <mjg@redhat.com>, Len Brown <lenb@kernel.org>,
       Thomas Renninger <trenn@suse.de>, linux-acpi@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] ACPI: add "auto" to acpi_enforce_resources
Message-ID: <20090330093641.66bd520b@hyperion.delvare>
In-Reply-To: <20090329220127.GA12822@dreamland.darkstar.lan>
References: <20090204142015.GB3923@srcf.ucam.org>
	<20090210145716.105ab58b@hyperion.delvare>
	<20090210140829.GA25397@srcf.ucam.org>
	<49919E08.5050002@redhat.com>
	<20090210172408.400cacee@hyperion.delvare>
	<20090227132740.GF1482@ucw.cz>
	<68676e00903240539i119b6d26j516ee131d4cd6781@mail.gmail.com>
	<49C8DE51.2010103@redhat.com>
	<20090329201617.GA10303@dreamland.darkstar.lan>
	<20090329225501.0c1771f1@hyperion.delvare>
	<20090329220127.GA12822@dreamland.darkstar.lan>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Mar 2009 00:01:27 +0200, Luca Tettamanti wrote:
> here's a revised patch:
> ---
> 
> The following patch changes the default value for option "acpi_enforce_resource"
> to strict. It enforces strict resource checking - disallowing access by native
> drivers to IO ports and memory regions claimed by ACPI firmware.
> 
> The patch is mainly aimed to block native hwmon drivers from touching
> monitoring chips that ACPI thinks it own.
> 
> Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>

Acked-by: Jean Delvare <jdelvare@suse.de>

> ---
>  Documentation/kernel-parameters.txt |   16 ++++++++++++++++
>  drivers/acpi/osl.c                  |    6 +++---
>  2 files changed, 19 insertions(+), 3 deletions(-)
> 
> Index: b/Documentation/kernel-parameters.txt
> ===================================================================
> --- a/Documentation/kernel-parameters.txt	2009-03-29 23:58:11.574893074 +0200
> +++ b/Documentation/kernel-parameters.txt	2009-03-29 23:58:31.582894852 +0200
> @@ -259,6 +259,22 @@
>  			to assume that this machine's pmtimer latches its value
>  			and always returns good values.
>  
> +	acpi_enforce_resources=	[ACPI]
> +			{ strict | lax | no }
> +			Check for resource conflicts between native drivers
> +			and ACPI OperationRegions (SystemIO and SystemMemory
> +			only). IO ports and memory declared in ACPI might be
> +			used by the ACPI subsystem in arbitrary AML code and
> +			can interfere with legacy drivers.
> +			strict (default): access to resources claimed by ACPI
> +			is denied; legacy drivers trying to access reserved
> +			resources will fail to bind to device using them.
> +			lax: access to resources claimed by ACPI is allowed;
> +			legacy drivers trying to access reserved resources
> +			will bind successfully but a warning message is logged.
> +			no: ACPI OperationRegions are not marked as reserved,
> +			no further checks are performed.
> +
>  	agp=		[AGP]
>  			{ off | try_unsupported }
>  			off: disable AGP support
> Index: b/drivers/acpi/osl.c
> ===================================================================
> --- a/drivers/acpi/osl.c	2009-03-29 23:58:11.942913535 +0200
> +++ b/drivers/acpi/osl.c	2009-03-29 23:58:31.586892815 +0200
> @@ -1070,9 +1070,9 @@
>   * in arbitrary AML code and can interfere with legacy drivers.
>   * acpi_enforce_resources= can be set to:
>   *
> - *   - strict           (2)
> + *   - strict (default) (2)
>   *     -> further driver trying to access the resources will not load
> - *   - lax (default)    (1)
> + *   - lax              (1)
>   *     -> further driver trying to access the resources will load, but you
>   *     get a system message that something might go wrong...
>   *
> @@ -1084,7 +1084,7 @@
>  #define ENFORCE_RESOURCES_LAX    1
>  #define ENFORCE_RESOURCES_NO     0
>  
> -static unsigned int acpi_enforce_resources = ENFORCE_RESOURCES_LAX;
> +static unsigned int acpi_enforce_resources = ENFORCE_RESOURCES_STRICT;
>  
>  static int __init acpi_enforce_resources_setup(char *str)
>  {
> 
> 
> Luca


-- 
Jean Delvare
