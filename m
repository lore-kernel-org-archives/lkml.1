Return-Path: <linux-kernel-owner+w=401wt.eu-S1752169AbXDJEqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbXDJEqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 00:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752357AbXDJEqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 00:46:35 -0400
Received: from gate.crashing.org ([63.228.1.57]:34365 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325AbXDJEqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 00:46:23 -0400
Subject: Re: [QUICKLIST 1/4] Quicklists for page table pages V5
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, ak@suse.de,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <20070409182509.8559.33823.sendpatchset@schroedinger.engr.sgi.com>
References: <20070409182509.8559.33823.sendpatchset@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Tue, 10 Apr 2007 14:45:37 +1000
Message-Id: <1176180337.8061.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-09 at 11:25 -0700, Christoph Lameter wrote:

> Quicklists for page table pages V5

Looks interesting, but unfortunately not very useful at this point for
powerpc unless you remove the assumption that quicklists contain
pages...

On powerpc, we currently use kmem cache slabs (though that isn't
terribly node friendly) whose sizes depend on the page size.

For a 4K page size kernel, we have 4 level page tables and use 2 caches,
PTE and PGD pages are 4K (thus are PAGE_SIZE'd), and PMD & PUD are 1K.

For a 64K page size kernel, we have 3 level page tables and we use 3
caches: a PGD pages are 128 bytes (yeah, not big heh...), our pmd
pages are 32K (half a page) and PTE pages are PAGE_SIZE (64K).

Cheers,
Ben.


