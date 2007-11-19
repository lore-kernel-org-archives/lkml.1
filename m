Return-Path: <linux-kernel-owner+w=401wt.eu-S1754606AbXKSWuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbXKSWuT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 17:50:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752429AbXKSWuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 17:50:08 -0500
Received: from relay1.sgi.com ([192.48.171.29]:52317 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752405AbXKSWuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 17:50:06 -0500
Date: Mon, 19 Nov 2007 14:50:03 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: root <root@programming.kicks-ass.net>
cc: Ingo Molnar <mingo@elte.hu>, Torsten Kaiser <just.for.lkml@googlemail.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       nfs@lists.sourceforge.net, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [BUG] 2.6.24-rc2-mm1 - kernel bug on nfs v4
In-Reply-To: <20071117230049.GA25905@dyad>
Message-ID: <Pine.LNX.4.64.0711191449360.15054@schroedinger.engr.sgi.com>
References: <473DA608.1020804@linux.vnet.ibm.com>
 <64bb37e0711170953p67d1be49lf4eaa190d662e2b4@mail.gmail.com>
 <20071117180946.GA14055@elte.hu> <20071117230049.GA25905@dyad>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Nov 2007, root wrote:

> @@ -2155,6 +2155,7 @@ static struct kmem_cache_node *early_kme
>  {
>  	struct page *page;
>  	struct kmem_cache_node *n;
> +	unsigned long flags;
>  
>  	BUG_ON(kmalloc_caches->size < sizeof(struct kmem_cache_node));
>  

Well local_irq_save is a bit of an overkill. We know that interrupts are 
enabled during this phase of the boot sequence.

