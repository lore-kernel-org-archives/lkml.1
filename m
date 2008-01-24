Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbYAXHHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbYAXHHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 02:07:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbYAXHHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 02:07:09 -0500
Received: from gate.crashing.org ([63.228.1.57]:48100 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265AbYAXHHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 02:07:08 -0500
Subject: Re: [PATCH v2][POWERPC] Always build setup-bus.c on powerpc
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Greg KH <greg@kroah.com>, linux-pci@atrey.karlin.mff.cuni.cz,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
In-Reply-To: <Pine.LNX.4.64.0801240037380.22221@blarg.am.freescale.net>
References: <Pine.LNX.4.64.0801240006380.21347@blarg.am.freescale.net>
	 <1201156120.6815.48.camel@pasglop>
	 <8642742F-E8BF-43C7-9FE4-AAF54855ECF7@kernel.crashing.org>
	 <Pine.LNX.4.64.0801240037380.22221@blarg.am.freescale.net>
Content-Type: text/plain
Date: Thu, 24 Jan 2008 18:06:35 +1100
Message-Id: <1201158395.6815.50.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-24 at 00:38 -0600, Kumar Gala wrote:
> The common arch/powerpc code calls in to functions in setup-bus.c
> so some builds of ppc32 would fail.
> 
> Note, ppc32 usage of setup-irq.c is limited to arch/ppc and should be
> removed when arch/ppc goes away.
> 
> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Ack. Funny I didn't catch it on my 4xx testing, I must have always had
HOTPLUG enabled.

> ---
> 
> Here's the proper diff, will send this via paulus.
> 
>  drivers/pci/Makefile |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
> index 5550556..f697f3d 100644
> --- a/drivers/pci/Makefile
> +++ b/drivers/pci/Makefile
> @@ -32,7 +32,7 @@ obj-$(CONFIG_ARM) += setup-bus.o setup-irq.o
>  obj-$(CONFIG_PARISC) += setup-bus.o
>  obj-$(CONFIG_SUPERH) += setup-bus.o setup-irq.o
>  obj-$(CONFIG_PPC32) += setup-irq.o
> -obj-$(CONFIG_PPC64) += setup-bus.o
> +obj-$(CONFIG_PPC) += setup-bus.o
>  obj-$(CONFIG_MIPS) += setup-bus.o setup-irq.o
>  obj-$(CONFIG_X86_VISWS) += setup-irq.o
> 

