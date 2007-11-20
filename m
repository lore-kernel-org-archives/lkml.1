Return-Path: <linux-kernel-owner+w=401wt.eu-S1761782AbXKTCNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761782AbXKTCNQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 21:13:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760638AbXKTB7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:59:35 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39159 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760632AbXKTB7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:59:34 -0500
Date: Mon, 19 Nov 2007 17:59:33 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Miller <davem@davemloft.net>
cc: ak@suse.de, akpm@linux-foundation.org, travis@sgi.com,
       mathieu.desnoyers@polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [rfc 00/45] [RFC] CPU ops and a rework of per cpu data handling
 on x86_64
In-Reply-To: <20071119.175116.55102316.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0711191758390.19954@schroedinger.engr.sgi.com>
References: <20071120011132.143632442@sgi.com> <20071119.175116.55102316.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2007, David Miller wrote:

> Although we have a per-cpu area base in a fixed global register
> for addressing, the above isn't beneficial on sparc64 because
> the atomic is much slower than doing a:
> 
> 	local_irq_disable();
> 	nonatomic_percpu_memory_op();
> 	local_irq_enable();
> 
> local_irq_{disable,enable}() together is about 18 cycles.
> Just the cmpxchg() part of the atomic sequence is at least
> 32 cycles and requires a loop:
> 
> 	while (1) {
> 		x = ld();
> 		if (cmpxchg(x, op(x)))
> 			break;
> 	}
> 
> which bloats up the atomic version even more.

In that case the generic fallbacks can just provide what you already have.

