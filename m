Return-Path: <linux-kernel-owner+w=401wt.eu-S933730AbXCMVsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933730AbXCMVsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 17:48:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933740AbXCMVsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 17:48:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58872
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933730AbXCMVsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 17:48:06 -0400
Date: Tue, 13 Mar 2007 14:48:05 -0700 (PDT)
Message-Id: <20070313.144805.28789513.davem@davemloft.net>
To: mpm@selenic.com
Cc: jeremy@goop.org, nickpiggin@yahoo.com.au, akpm@linux-foundation.org,
       clameter@sgi.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [QUICKLIST 0/4] Arch independent quicklists V2
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070313211435.GP10394@waste.org>
References: <20070313202125.GO10394@waste.org>
	<20070313.140722.72711732.davem@davemloft.net>
	<20070313211435.GP10394@waste.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Mackall <mpm@selenic.com>
Date: Tue, 13 Mar 2007 16:14:35 -0500

> Well you -could- do this:
> 
> - reuse a long in struct page as a used map that divides the page up
>   into 32 or 64 segments
> - every time you set a PTE, set the corresponding bit in the mask
> - when we zap, only visit the regions set in the mask
> 
> Thus, you avoid visiting most of a PMD page in the sparse case,
> assuming PTEs aren't evenly spread across the PMD.
> 
> This might not even be too horrible as the appropriate struct page
> should be in cache with the appropriate bits of the mm already locked,
> etc.

Yes, I've even had that idea before.

You can even hide it behind pmd_none() et al., the generic VM
doesn't even have to know that the page table macros are doing
this optimization.
