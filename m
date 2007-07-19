Return-Path: <linux-kernel-owner+w=401wt.eu-S936587AbXGSAvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936587AbXGSAvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 20:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbXGSAvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 20:51:36 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43701 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753335AbXGSAvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 20:51:35 -0400
Date: Wed, 18 Jul 2007 17:51:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       robert.moore@intel.com, len.brown@intel.com
Subject: Re: [PATCH][ACPI] Fix acpi_ev_pci_config_region_setup() to avoid
 memory leak
Message-Id: <20070718175126.40d845c5.akpm@linux-foundation.org>
In-Reply-To: <200707190048.03992.jesper.juhl@gmail.com>
References: <200707190048.03992.jesper.juhl@gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007 00:48:03 +0200
Jesper Juhl <jesper.juhl@gmail.com> wrote:

> Hello,
> 
> In drivers/acpi/events/evrgnini.c::acpi_ev_pci_config_region_setup() 
> there is a memory leak.
> We may return at "if (!pci_device_node)" without freeing storage 
> previously allocated and assigned to 'pci_id'.
> This patch fixes the leak by freeing the allocated storage in this 
> case.
> 
> Compile tested only...
> 
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> ---
> 
>  drivers/acpi/events/evrgnini.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/acpi/events/evrgnini.c b/drivers/acpi/events/evrgnini.c
> index 400d90f..10f378b 100644
> --- a/drivers/acpi/events/evrgnini.c
> +++ b/drivers/acpi/events/evrgnini.c
> @@ -284,6 +284,7 @@ acpi_ev_pci_config_region_setup(acpi_handle handle,
>  	}
>  
>  	if (!pci_device_node) {
> +		kfree(pci_id);
>  		return_ACPI_STATUS(AE_AML_OPERAND_TYPE);
>  	}
>  

We're supposed to use the attractive ACPI_FREE() here.  I'll make that
change.

