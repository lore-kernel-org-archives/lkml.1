Return-Path: <linux-kernel-owner+w=401wt.eu-S1754368Ab0AaUD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab0AaUD1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 15:03:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754344Ab0AaUDY
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 15:03:24 -0500
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:49383 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754157Ab0AaUDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 15:03:20 -0500
X-Trace: 337118227/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.93.110/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.93.110
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-Originating-Country: GB/UNITED KINGDOM
X-MUA: Alpine 2.00 (LSU 1167 2008-08-23)
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlcBAIdwZUtPRV1u/2dsb2JhbAAI1h2ERQQ
X-IronPort-AV: E=Sophos;i="4.49,378,1262563200"; 
   d="scan'208";a="337118227"
Date: Sun, 31 Jan 2010 20:03:16 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Tony Perkins <da.perk@gmail.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-mm@kvack.org
Subject: Re: Bug in find_vma_prev - mmap.c
In-Reply-To: <6cafb0f01001311056k3c6a882fla42b714256bb1e6d@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1001311955510.6227@sister.anvils>
References: <6cafb0f01001291657q4ccbee86rce3143a4be7a1433@mail.gmail.com>  <201001301929.47659.rjw@sisk.pl>  <alpine.LSU.2.00.1001311616590.5897@sister.anvils> <6cafb0f01001311056k3c6a882fla42b714256bb1e6d@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 Jan 2010, Tony Perkins wrote:
> 
> Say for instance, that addr is not in the list (but is greater than
> the last element).

Before, you appeared to be talking about a discrepancy with the first
vma; now you're talking about a discrepancy with the last vma?
Or a discrepancy when the first vma is the last vma?

> find_vma_prev will return the last node in the list, whereas find_vma
> will return NULL.

I'd expect find_vma_prev to return prev->vm_next, which would be NULL.

> 
> It seems that it is just inconsistent, in what it should return
> regarding the two.
> For instance, find_vma_prev will never return NULL, if there's at
> least one node within the tree, whereas find_vma would.
> find_extend_vma uses find_vma_prev and checks to see if it returns
> NULL and is less than the return address (which would always be the
> case).

Are we disagreeing about our readings of the code, or have you seen a
problem in practice?

I admit I've not tried running this, injecting addresses into find_vma_prev
and printk'ing the result; but I'm missing what leads you to say that
find_vma_prev will never return NULL.

Hugh
