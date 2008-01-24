Return-Path: <linux-kernel-owner+w=401wt.eu-S1754820AbYAXG3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbYAXG3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 01:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbYAXG3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 01:29:11 -0500
Received: from gate.crashing.org ([63.228.1.57]:41807 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684AbYAXG3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 01:29:10 -0500
Subject: Re: [PATCH] [POWERPC] Always build setup-bus.c on powerpc
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Greg KH <greg@kroah.com>, linux-pci@atrey.karlin.mff.cuni.cz,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <Pine.LNX.4.64.0801240006380.21347@blarg.am.freescale.net>
References: <Pine.LNX.4.64.0801240006380.21347@blarg.am.freescale.net>
Content-Type: text/plain
Date: Thu, 24 Jan 2008 17:28:40 +1100
Message-Id: <1201156120.6815.48.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-24 at 00:07 -0600, Kumar Gala wrote:
> The common arch/powerpc code calls in to functions in setup-bus.c
> so some builds of ppc32 would fail.
> 
> Note, ppc32 usage of setup-irq.c is limited to arch/ppc and should be
> removed when arch/ppc goes away.

I don't understand... the old code would build setup-bus.o for both
PPC32 and PPC64 cases, how did you make it fail ?

Ben.

> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
> ---
> 
> Greg, recent changes that BenH has made to the arch/powerpc pci code make
> this necessary. If you don't have an issue I'd like this patch to go via
> the paulus's powerpc.git tree.
> 
> - k
> 
>  drivers/pci/Makefile |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
> index 945bf02..869d689 100644
> --- a/drivers/pci/Makefile
> +++ b/drivers/pci/Makefile
> @@ -31,8 +31,8 @@ obj-$(CONFIG_ALPHA) += setup-bus.o setup-irq.o
>  obj-$(CONFIG_ARM) += setup-bus.o setup-irq.o
>  obj-$(CONFIG_PARISC) += setup-bus.o
>  obj-$(CONFIG_SUPERH) += setup-bus.o setup-irq.o
> -obj-$(CONFIG_PPC32) += setup-irq.o setup-bus.o
> -obj-$(CONFIG_PPC64) += setup-bus.o
> +obj-$(CONFIG_PPC) += setup-bus.o
> +obj-$(CONFIG_PPC32) += setup-irq.o
>  obj-$(CONFIG_MIPS) += setup-bus.o setup-irq.o
>  obj-$(CONFIG_X86_VISWS) += setup-irq.o
> 

