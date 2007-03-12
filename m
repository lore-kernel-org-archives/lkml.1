Return-Path: <linux-kernel-owner+w=401wt.eu-S965551AbXCLLMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965551AbXCLLMg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 07:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965564AbXCLLMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 07:12:35 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59092 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965551AbXCLLMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 07:12:34 -0400
Date: Mon, 12 Mar 2007 04:12:32 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Miller <davem@davemloft.net>
cc: linux-kernel@vger.kernel.org, ak@suse.com, holt@sgi.com,
       linux-ia64@vger.kernel.org, mpm@selenic.com
Subject: Re: [QUICKLIST 0/6] Arch independent quicklists V1
In-Reply-To: <20070311.135946.28788670.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0703120409150.25910@schroedinger.engr.sgi.com>
References: <20070311020923.19905.49260.sendpatchset@schroedinger.engr.sgi.com>
 <20070311.135946.28788670.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Mar 2007, David Miller wrote:

> I'm going to make the radical declaration that it be perhaps often
> better to always initialize page table chunks to all zeros on
> allocation.

That is the case if most of the page is going to be used soon. If we have 
sparse access patterns then not zeroing can avoid uselessly bringing 
cachelines in.

> The reason is that every time I've monitored the allocation patterns
> of these things on SMP, the page table chunks always get released on a
> different cpu than where they were initialized.

But its even advantageous in that case for sparse allocs.
 
> The allocator side just does nothing but emit L2 cache line ownership
> transactions as the pte page is touched.  Especially on chips like
> PowerPC where zero initialization is absurdly cheap, we can avoid all
> of the cache line transfers if we just initialize it at allocation
> time.

We have no need to touch all the cache lines w/o initialization if we 
alloc from the quicklist. And that is a performance benefit.

