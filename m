Return-Path: <linux-kernel-owner+w=401wt.eu-S933004AbXCOHbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004AbXCOHbW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 03:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932975AbXCOHbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 03:31:22 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41117
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932231AbXCOHbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 03:31:21 -0400
Date: Thu, 15 Mar 2007 00:31:18 -0700 (PDT)
Message-Id: <20070315.003118.41650094.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: paulus@samba.org, clameter@sgi.com, linux-kernel@vger.kernel.org,
       ak@suse.com, holt@sgi.com, linux-ia64@vger.kernel.org, mpm@selenic.com
Subject: Re: [QUICKLIST 0/6] Arch independent quicklists V1
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070315002249.9e531578.akpm@linux-foundation.org>
References: <20070312.192616.63128242.davem@davemloft.net>
	<20070312.193211.30184040.davem@davemloft.net>
	<20070315002249.9e531578.akpm@linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 15 Mar 2007 00:22:49 -0800

> So...  what would happen if sparc64 were to use neither quicklists nor
> slab?  Just grab these pages from the page allocator and clear them?

The page table allocator is heavier weight than the quicklists,
although obviously not as heavy weight as SLAB.

I know special purpose allocation lists suck, but they really help in
this case in my opinion.

And for the x86 cases it's not going to help to have GFP_ZERO stuff
via the page allocator for page tables, they have to have specific
bits in the pre-initialized areas for the kernel PGDs, not just zero.
