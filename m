Return-Path: <linux-kernel-owner+w=401wt.eu-S1946214AbXBCBjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946214AbXBCBjI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 20:39:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946213AbXBCBjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 20:39:08 -0500
Received: from smtp.osdl.org ([65.172.181.24]:49213 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946210AbXBCBjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 20:39:03 -0500
Date: Fri, 2 Feb 2007 17:37:46 -0800
From: Andrew Morton <akpm@osdl.org>
To: John Keller <jpk@sgi.com>
Cc: linux-acpi@vger.kernel.org, ayoung@sgi.com, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
       "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH 1/1] -  Altix: more ACPI PRT support
Message-Id: <20070202173746.9fc66172.akpm@linux-foundation.org>
In-Reply-To: <20070202205412.14367.60290.sendpatchset@attica.americas.sgi.com>
References: <20070202205412.14367.60290.sendpatchset@attica.americas.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Feb 2007 14:54:12 -0600
John Keller <jpk@sgi.com> wrote:

> The SN Altix platform does not conform to the 
> IOSAPIC IRQ routing model. Add code in acpi_unregister_gsi()
> to check if (acpi_irq_model == ACPI_IRQ_MODEL_PLATFORM) and
> return.
> 
> Signed-off-by: John Keller <jpk@sgi.com>
> ---
> 
> Due to an oversight, this code was not added previously when
> similar code was added to acpi_register_gsi().
> 
> http://marc.theaimsgroup.com/?l=linux-acpi&m=116680983430121&w=2
> 
>  arch/ia64/kernel/acpi.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> 
> Index: linux-2.6/arch/ia64/kernel/acpi.c
> ===================================================================
> --- linux-2.6.orig/arch/ia64/kernel/acpi.c	2007-02-02 14:44:31.000000000 -0600
> +++ linux-2.6/arch/ia64/kernel/acpi.c	2007-02-02 14:47:44.658143727 -0600
> @@ -609,6 +609,9 @@ EXPORT_SYMBOL(acpi_register_gsi);
>  
>  void acpi_unregister_gsi(u32 gsi)
>  {
> +	if (acpi_irq_model == ACPI_IRQ_MODEL_PLATFORM)
> +		return;
> +
>  	iosapic_unregister_intr(gsi);
>  }

Given that the December 22 patch appears to be in mainline, and that this
patch is simple, I shall cheerily bypass maintainers and send it in for
2.6.20.

