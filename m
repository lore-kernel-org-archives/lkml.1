Return-Path: <linux-kernel-owner+w=401wt.eu-S1030792AbXDKEEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030792AbXDKEEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 00:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030795AbXDKEEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 00:04:50 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:55415 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030792AbXDKEEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 00:04:49 -0400
Date: Tue, 10 Apr 2007 21:04:47 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, ak@suse.de,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [QUICKLIST 1/4] Quicklists for page table pages V5
In-Reply-To: <1176180337.8061.21.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0704102058420.18321@schroedinger.engr.sgi.com>
References: <20070409182509.8559.33823.sendpatchset@schroedinger.engr.sgi.com>
 <1176180337.8061.21.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Apr 2007, Benjamin Herrenschmidt wrote:

> On Mon, 2007-04-09 at 11:25 -0700, Christoph Lameter wrote:
> 
> > Quicklists for page table pages V5
> 
> Looks interesting, but unfortunately not very useful at this point for
> powerpc unless you remove the assumption that quicklists contain
> pages...

Then quicklists wont be as simple anymore.

> On powerpc, we currently use kmem cache slabs (though that isn't
> terribly node friendly) whose sizes depend on the page size.
> 
> For a 4K page size kernel, we have 4 level page tables and use 2 caches,
> PTE and PGD pages are 4K (thus are PAGE_SIZE'd), and PMD & PUD are 1K.

PTE and PGD could be run via quicklists? With PTEs you cover the most 
common case. Quicklists using PGDs will allow to optimize using 
preconstructed pages.

Its probably best to keep the slabs for the 1K pages.
 
> For a 64K page size kernel, we have 3 level page tables and we use 3
> caches: a PGD pages are 128 bytes (yeah, not big heh...), our pmd
> pages are 32K (half a page) and PTE pages are PAGE_SIZE (64K).

Ok so use quicklists for the PTEs and slab for the rest? A PGD of only 128 
bytes? Stuff one at the end of the mm_struct or the task struct? That way 
you can avoid allocation overhead.
