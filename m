Return-Path: <linux-kernel-owner+w=401wt.eu-S1758450AbYDGXuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758450AbYDGXuf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 19:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbYDGXu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 19:50:28 -0400
Received: from gate.crashing.org ([63.228.1.57]:43473 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930AbYDGXu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 19:50:27 -0400
Subject: Re: [PATCH 1/1 resend][PPC] replace logical by bitand in
	pci_process_ISA_OF_ranges(), arch/powerpc/kernel/isa-bridge.c
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Roel Kluin <12o3l@tiscali.nl>
Cc: jwboyer@linux.vnet.ibm.com, linuxppc-dev@ozlabs.org,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <47FA9FA6.8090201@tiscali.nl>
References: <47FA9FA6.8090201@tiscali.nl>
Content-Type: text/plain
Date: Tue, 08 Apr 2008 09:50:10 +1000
Message-Id: <1207612210.10388.492.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-04-08 at 00:26 +0200, Roel Kluin wrote:
> in arch/powerpc/kernel/isa-bridge.c:
> 41:#define ISA_SPACE_MASK 0x1
> 42:#define ISA_SPACE_IO 0x1
> ...
> 
> 83:    if ((range->isa_addr.a_hi && ISA_SPACE_MASK) != ISA_SPACE_IO) {
> ...
> 89:    if ((range->isa_addr.a_hi && ISA_SPACE_MASK) != ISA_SPACE_IO)
> 
> I think these should be single &'s, I can't test it (no hardware)
> please consider the patch below.
> --
> replace logical by bit and for ISA_SPACE_MASK
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

> ---
> diff --git a/arch/powerpc/kernel/isa-bridge.c b/arch/powerpc/kernel/isa-bridge.c
> index f0f49d1..406a9e6 100644
> --- a/arch/powerpc/kernel/isa-bridge.c
> +++ b/arch/powerpc/kernel/isa-bridge.c
> @@ -80,13 +80,13 @@ static void __devinit pci_process_ISA_OF_ranges(struct device_node *isa_node,
>  	 *			(size depending on dev->n_addr_cells)
>  	 *   cell 5:		the size of the range
>  	 */
> -	if ((range->isa_addr.a_hi && ISA_SPACE_MASK) != ISA_SPACE_IO) {
> +	if ((range->isa_addr.a_hi & ISA_SPACE_MASK) != ISA_SPACE_IO) {
>  		range++;
>  		rlen -= sizeof(struct isa_range);
>  		if (rlen < sizeof(struct isa_range))
>  			goto inval_range;
>  	}
> -	if ((range->isa_addr.a_hi && ISA_SPACE_MASK) != ISA_SPACE_IO)
> +	if ((range->isa_addr.a_hi & ISA_SPACE_MASK) != ISA_SPACE_IO)
>  		goto inval_range;
>  
>  	isa_addr = range->isa_addr.a_lo;
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev

