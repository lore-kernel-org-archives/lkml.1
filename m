Return-Path: <linux-kernel-owner+w=401wt.eu-S1753458AbZHXUjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbZHXUjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 16:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbZHXUje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 16:39:34 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:12325 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752660AbZHXUje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 16:39:34 -0400
X-Trace: 251584883/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.38.113/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.38.113
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsIEAAeXkkpQKSZx/2dsb2JhbACBU9VXhBoF
X-IronPort-AV: E=Sophos;i="4.44,267,1249254000"; 
   d="scan'208";a="251584883"
Date: Mon, 24 Aug 2009 21:39:02 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Nitin Gupta <ngupta@vflare.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-mm-cc@laptop.org
Subject: Re: [PATCH 1/4] compcache: xvmalloc memory allocator
In-Reply-To: <4A92EBB4.1070101@vflare.org>
Message-ID: <Pine.LNX.4.64.0908242132320.8144@sister.anvils>
References: <200908241007.47910.ngupta@vflare.org>
 <84144f020908241033l4af09e7h9caac47d8d9b7841@mail.gmail.com>
 <4A92EBB4.1070101@vflare.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Aug 2009, Nitin Gupta wrote:
> On 08/24/2009 11:03 PM, Pekka Enberg wrote:
> >
> > What's the purpose of passing PFNs around? There's quite a lot of PFN
> > to struct page conversion going on because of it. Wouldn't it make
> > more sense to return (and pass) a pointer to struct page instead?
> 
> PFNs are 32-bit on all archs

Are you sure?  If it happens to be so for all machines built today,
I think it can easily change tomorrow.  We consistently use unsigned long
for pfn (there, now I've said that, I bet you'll find somewhere we don't!)

x86_64 says MAX_PHYSMEM_BITS 46 and ia64 says MAX_PHYSMEM_BITS 50 and
mm/sparse.c says
unsigned long max_sparsemem_pfn = 1UL << (MAX_PHYSMEM_BITS-PAGE_SHIFT);

Hugh
