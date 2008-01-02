Return-Path: <linux-kernel-owner+w=401wt.eu-S1757925AbYABUou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925AbYABUou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 15:44:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbYABUok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 15:44:40 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34166 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbYABUoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:44:39 -0500
Date: Wed, 2 Jan 2008 20:44:35 +0000
From: Christoph Hellwig <hch@infradead.org>
To: schwidefsky@de.ibm.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch 2/3] CONFIG_HIGHPTE vs. sub-page page tables.
Message-ID: <20080102204435.GB15460@infradead.org>
References: <20071112143009.425807965@de.ibm.com> <20071112144009.831296895@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071112144009.831296895@de.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2007 at 03:30:11PM +0100, schwidefsky@de.ibm.com wrote:
> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Solution: The only solution I found to this dilemma is a new typedef:
> a pgtable_t. For s390 pgtable_t will be a (pte *) - to be introduced
> with a later patch. For everybody else it will be a (struct page *).
> The additional problem with the initialization of the ptl lock and the
> NR_PAGETABLE accounting is solved with a constructor pgtable_page_ctor
> and a destructor pgtable_page_dtor. The page table allocation and free
> functions need to call these two whenever a page table page is allocated
> or freed. pmd_populate will get a pgtable_t instead of a struct page
> pointer. To get the pgtable_t back from a pmd entry that has been
> installed with pmd_populate a new function pmd_pgtable is added. It
> replaces the pmd_page call in free_pte_range and apply_to_pte_range.

Can we please just nuke CONFIG_HIGHPTE?  There's only been a small
amount of 32bit machines with so much memory that they'd need it
and they can happily stay on the currently supported enterprise
distro releases instead of dragging this cruft around forever.

