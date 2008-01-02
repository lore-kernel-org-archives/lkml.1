Return-Path: <linux-kernel-owner+w=401wt.eu-S1755644AbYABUvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644AbYABUvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 15:51:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754351AbYABUvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 15:51:24 -0500
Received: from relay1.sgi.com ([192.48.171.29]:58158 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753887AbYABUvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:51:23 -0500
Date: Wed, 2 Jan 2008 12:51:20 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Torsten Kaiser <just.for.lkml@googlemail.com>
cc: root <root@dyad.programming.kicks-ass.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>,
       Jan Blunck <jblunck@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [BUG] 2.6.24-rc2-mm1 - kernel bug on nfs v4
In-Reply-To: <64bb37e0801021043l26e33aafpa08265b44f0f4c82@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0801021249560.21526@schroedinger.engr.sgi.com>
References: <473DA608.1020804@linux.vnet.ibm.com> 
 <64bb37e0711170953p67d1be49lf4eaa190d662e2b4@mail.gmail.com> 
 <20071117180946.GA14055@elte.hu> <20071117230049.GA25905@dyad>
 <64bb37e0801021043l26e33aafpa08265b44f0f4c82@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jan 2008, Torsten Kaiser wrote:

> I just tested something with vanilla 2.6.24-rc6 and had the same problem.
> Should this patch, or something similar be included for 2.6.24?

Such a patch is in Andrew's tree.

2.6.24-rc6-mm1:

tatic struct kmem_cache_node *early_kmem_cache_node_alloc(gfp_t gfpflags,
                                                           int node)
{
        struct page *page;
        struct kmem_cache_node *n;
        unsigned long flags;
...

    /*
         * lockdep requires consistent irq usage for each lock
         * so even though there cannot be a race this early in
         * the boot sequence, we still disable irqs.
         */
        local_irq_save(flags);
        add_partial(kmalloc_caches, page, 0);
        local_irq_restore(flags);
        return n;
}
