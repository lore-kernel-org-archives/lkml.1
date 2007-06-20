Return-Path: <linux-kernel-owner+w=401wt.eu-S1761473AbXFTDeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761473AbXFTDeO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 23:34:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758882AbXFTDd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 23:33:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:36380 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421AbXFTDd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 23:33:58 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: "Andreas Herrmann" <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 3/12] acpi: fix compile error with ACPI && !ACPI_POWER
Date: Tue, 19 Jun 2007 23:33:47 -0400
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <20070619224858.GE5193@alberich.amd.com>
In-Reply-To: <20070619224858.GE5193@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706192333.47687.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 June 2007 18:48, Andreas Herrmann wrote:
> Fix compile error with ACPI && !ACPI_POWER as bus.c
> depends on power.c

How were you able to set CONFIG_ACPI_POWER=n to cause this compile error?

When I do that, "make oldconfig" forces it to =y.

-Len

> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> ---
>  drivers/acpi/Kconfig  |    4 ----
>  drivers/acpi/Makefile |    2 +-
>  2 files changed, 1 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
> index 139f41f..9d6baab 100644
> --- a/drivers/acpi/Kconfig
> +++ b/drivers/acpi/Kconfig
> @@ -288,10 +288,6 @@ config ACPI_EC
>  	  the battery and thermal drivers.  If you are compiling for a 
>  	  mobile system, say Y.
>  
> -config ACPI_POWER
> -	bool
> -	default y
> -
>  config ACPI_SYSTEM
>  	bool
>  	default y
> diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
> index d4336f1..9485cc3 100644
> --- a/drivers/acpi/Makefile
> +++ b/drivers/acpi/Makefile
> @@ -48,7 +48,7 @@ obj-$(CONFIG_ACPI_DOCK)		+= dock.o
>  obj-$(CONFIG_ACPI_BAY)		+= bay.o
>  obj-$(CONFIG_ACPI_VIDEO)	+= video.o
>  obj-y				+= pci_root.o pci_link.o pci_irq.o pci_bind.o
> -obj-$(CONFIG_ACPI_POWER)	+= power.o
> +obj-y				+= power.o
>  obj-$(CONFIG_ACPI_PROCESSOR)	+= processor.o
>  obj-$(CONFIG_ACPI_CONTAINER)	+= container.o
>  obj-$(CONFIG_ACPI_THERMAL)	+= thermal.o
