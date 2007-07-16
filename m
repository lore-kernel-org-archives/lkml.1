Return-Path: <linux-kernel-owner+w=401wt.eu-S1762852AbXGPGVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762852AbXGPGVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 02:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbXGPGU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 02:20:56 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40591 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752945AbXGPGU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 02:20:56 -0400
Date: Sun, 15 Jul 2007 23:20:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: hugh@veritas.com, peterz@infradead.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [patch 1/5] avoid tlb gather restarts.
Message-Id: <20070715232031.5479614e.akpm@linux-foundation.org>
In-Reply-To: <20070703121228.254110263@de.ibm.com>
References: <20070703111822.418649776@de.ibm.com>
	<20070703121228.254110263@de.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Jul 2007 13:18:23 +0200 Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> If need_resched() is false in the inner loop of unmap_vmas it is
> unnecessary to do a full blown tlb_finish_mmu / tlb_gather_mmu for
> each ZAP_BLOCK_SIZE ptes. Do a tlb_flush_mmu() instead. That gives
> architectures with a non-generic tlb flush implementation room for
> optimization. The tlb_flush_mmu primitive is a available with the
> generic tlb flush code, the ia64_tlb_flush_mm needs to be renamed
> and a dummy function is added to arm and arm26.
> 
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> ---
> 
>  include/asm-arm/tlb.h   |    5 +++++
>  include/asm-arm26/tlb.h |    5 +++++
>  include/asm-ia64/tlb.h  |    6 +++---
>  mm/memory.c             |   16 ++++++----------
>  4 files changed, 19 insertions(+), 13 deletions(-)

sparc64 broke:

mm/memory.c: In function `unmap_vmas':
mm/memory.c:862: error: too many arguments to function `tlb_flush_mmu'

grep, please.
