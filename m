Return-Path: <linux-kernel-owner+w=401wt.eu-S1750964AbXCTXua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750964AbXCTXua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 19:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751006AbXCTXua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 19:50:30 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:34289 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbXCTXu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 19:50:29 -0400
Subject: Re: [PATCH 0/7] [RFC] hugetlb: pagetable_operations API (V2)
From: Dave Hansen <hansendc@us.ibm.com>
To: Adam Litke <agl@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Christoph Hellwig <hch@infradead.org>, Ken Chen <kenchen@google.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070319200502.17168.17175.stgit@localhost.localdomain>
References: <20070319200502.17168.17175.stgit@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 20 Mar 2007 16:50:13 -0700
Message-Id: <1174434613.26166.182.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-19 at 13:05 -0700, Adam Litke wrote:
> For the common case (vma->pagetable_ops == NULL), we do almost the
> same thing as the current code: load and test.  The third instruction
> is different in that we jump for the common case instead of jumping in
> the hugetlb case.  I don't think this is a big deal though.  If it is,
> would an unlikely() macro fix it? 

I wouldn't worry about micro-optimizing it at that level.  The CPU does
enough stuff under the covers that I wouldn't worry about it at all.

I wonder if the real differential impact (if any) is likely to come from
the pagetable_ops cacheline being hot or cold, since it is in a
different place in the structure than the flags.  But, from a quick
glance I see a few vm_ops references preceding pagetable_ops references,
so the pagetable_ops cacheline might already be hot most of the time.  

BTW, are there any other possible users for these things other than
large pages?

-- Dave

