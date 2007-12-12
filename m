Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbXLLEqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbXLLEqb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 23:46:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbXLLEqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 23:46:24 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34166 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751089AbXLLEqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 23:46:23 -0500
Date: Tue, 11 Dec 2007 20:46:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pci: don't load acpi_php when acpi is disabled
Message-Id: <20071211204620.6c9acf54.akpm@linux-foundation.org>
In-Reply-To: <200712112014.40923.yinghai.lu@sun.com>
References: <200712112014.40923.yinghai.lu@sun.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Dec 2007 20:14:40 -0800 Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> [PATCH] pci: don't load acpi_php when acpi is disabled
> 
> when acpi=off and pci=nomsi, don't load acpiphp
> 
> Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
> 
> diff --git a/drivers/pci/hotplug/acpiphp_core.c b/drivers/pci/hotplug/acpiphp_core.c
> index c8c2638..84d66ba 100644
> --- a/drivers/pci/hotplug/acpiphp_core.c
> +++ b/drivers/pci/hotplug/acpiphp_core.c
> @@ -392,6 +392,9 @@ static int __init acpiphp_init(void)
>  {
>  	info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
>  
> +	if (acpi_pci_disabled)
> +		return 0;
> +
>  	acpiphp_debug = debug;
>  
>  	/* read all the ACPI info from the system */
> @@ -401,6 +404,9 @@ static int __init acpiphp_init(void)
>  
>  static void __exit acpiphp_exit(void)
>  {
> +	if (acpi_pci_disabled)
> +		return 0;
> +
>  	/* deallocate internal data structures etc. */
>  	acpiphp_glue_exit();
>  }

OK, but there is some information missing in your patch descriptions: what
effect do these patches have?  Does the kernel crash without them?  Or is
there no effect at all?  Or something in between?

Thanks.
