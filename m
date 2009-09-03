Return-Path: <linux-kernel-owner+w=401wt.eu-S932432AbZICWpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432AbZICWpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 18:45:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932070AbZICWpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 18:45:07 -0400
Received: from gate.crashing.org ([63.228.1.57]:52394 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647AbZICWpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 18:45:06 -0400
Subject: Re: [PATCH] powerpc: Fix i8259 interrupt driver kernel crash on
 ML510
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org,
       Roderick Colenbrander <thunderbird2k@gmail.com>
In-Reply-To: <20090903155208.18009.73841.stgit@localhost.localdomain>
References: <20090903155208.18009.73841.stgit@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 04 Sep 2009 08:44:19 +1000
Message-Id: <1252017859.15089.44.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-03 at 09:57 -0600, Grant Likely wrote:
> From: Roderick Colenbrander <thunderbird2k@gmail.com>
> 
> This patch fixes a null pointer exception caused by removal of
> 'ack()' for level interrupts in the Xilinx interrupt driver.  A recent
> change to the xilinx interrupt controller removed the ack hook for
> level irqs.
> 
> Signed-off-by: Roderick Colenbrander <thunderbird2k@gmail.com>
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

My git trees aren't at hand, so Linus feel free to merge that directly.

Cheers,
Ben.

> 
> Hi Ben & Linus,
> 
> This is a last minute bug fix must go into 2.6.31.  This patch
> is needed to prevent a kernel panic on Xilinx ml510 boards.
> 
> I've also pushed the patch out to my git tree if you'd prefer to pull:
> 
> The following changes since commit 326ba5010a5429a5a528b268b36a5900d4ab0eba:
>   Linus Torvalds (1):
>         Linux 2.6.31-rc8
> 
> are available in the git repository at:
> 
>   git://git.secretlab.ca/git/linux-2.6 merge
> 
> Roderick Colenbrander (1):
>       powerpc: Fix i8259 interrupt driver kernel crash on ML510
> 
>  arch/powerpc/sysdev/xilinx_intc.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> 
> 
> diff --git a/arch/powerpc/sysdev/xilinx_intc.c b/arch/powerpc/sysdev/xilinx_intc.c
> index 3ee1fd3..40edad5 100644
> --- a/arch/powerpc/sysdev/xilinx_intc.c
> +++ b/arch/powerpc/sysdev/xilinx_intc.c
> @@ -234,7 +234,6 @@ static void xilinx_i8259_cascade(unsigned int irq, struct irq_desc *desc)
>  		generic_handle_irq(cascade_irq);
>  
>  	/* Let xilinx_intc end the interrupt */
> -	desc->chip->ack(irq);
>  	desc->chip->unmask(irq);
>  }
>  

