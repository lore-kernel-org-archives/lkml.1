Return-Path: <linux-kernel-owner+w=401wt.eu-S1756437AbXKTAzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437AbXKTAzo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 19:55:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbXKTAzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 19:55:23 -0500
Received: from gate.crashing.org ([63.228.1.57]:34221 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656AbXKTAzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 19:55:21 -0500
Subject: Re: SCSI breakage on non-cache coherent architectures
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: David Miller <davem@davemloft.net>
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk
In-Reply-To: <20071119.164611.64664648.davem@davemloft.net>
References: <1195501874.6539.5.camel@pasglop>
	 <20071119.143115.251022325.davem@davemloft.net>
	 <1195518864.6970.23.camel@pasglop>
	 <20071119.164611.64664648.davem@davemloft.net>
Content-Type: text/plain
Date: Tue, 20 Nov 2007 11:55:01 +1100
Message-Id: <1195520101.6970.28.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-11-19 at 16:46 -0800, David Miller wrote:
> 
> 1) Require that entire buffers are commited by call sites,
>    and thus "embedding" DMA'd within non-DMA stuff isn't allowed
> 
> 2) Add the __dma_cacheline_aligned tag.
> 
> But note that with #2 it could get quite ugly because the
> alignment and size both have a minimum that needs to be
> enforced, not just the alignment alone.  So either:

Yup.

> struct foo {
>         unsigned int other_unrelated_stuff;
> 
>         struct object dma_thing __dma_cacheline_aligned;
> 
>         unsigned int more_nondma_stuff __dma_cacheline_aligned;
> };

In my tests, I had used a "fuckton_t" object defined to be an empty
thing with alignment constraint, seemed to work :-) But I'd rather
require #1.

BTW. What is the status nowadays with skb's ?

Cheers,
Ben.

