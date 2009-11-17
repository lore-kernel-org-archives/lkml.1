Return-Path: <linux-kernel-owner+w=401wt.eu-S1753649AbZKQKPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649AbZKQKPX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 05:15:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbZKQKPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 05:15:22 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38020 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023AbZKQKPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 05:15:22 -0500
Date: Tue, 17 Nov 2009 05:15:26 -0500
From: Christoph Hellwig <hch@infradead.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/7] Kill PF_MEMALLOC abuse
Message-ID: <20091117101526.GA4797@infradead.org>
References: <20091117161551.3DD4.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091117161551.3DD4.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 04:16:04PM +0900, KOSAKI Motohiro wrote:
> Some subsystem paid attention (1) only, and start to use PF_MEMALLOC abuse.
> But, the fact is, PF_MEMALLOC is the promise of "I have lots freeable memory.
> if I allocate few memory, I can return more much meory to the system!".
> Non MM subsystem must not use PF_MEMALLOC. Memory reclaim
> need few memory, anyone must not prevent it. Otherwise the system cause
> mysterious hang-up and/or OOM Killer invokation.

And that's exactly the promises xfsbufd gives.  It writes out dirty
metadata buffers and will free lots of memory if you kick it. 

