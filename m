Return-Path: <linux-kernel-owner+w=401wt.eu-S1754342AbZKQKYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342AbZKQKYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 05:24:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbZKQKYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 05:24:39 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38291 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208AbZKQKYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 05:24:39 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/7] Kill PF_MEMALLOC abuse
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20091117101526.GA4797@infradead.org>
References: <20091117161551.3DD4.A69D9226@jp.fujitsu.com> <20091117101526.GA4797@infradead.org>
Message-Id: <20091117192232.3DF9.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 17 Nov 2009 19:24:42 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Nov 17, 2009 at 04:16:04PM +0900, KOSAKI Motohiro wrote:
> > Some subsystem paid attention (1) only, and start to use PF_MEMALLOC abuse.
> > But, the fact is, PF_MEMALLOC is the promise of "I have lots freeable memory.
> > if I allocate few memory, I can return more much meory to the system!".
> > Non MM subsystem must not use PF_MEMALLOC. Memory reclaim
> > need few memory, anyone must not prevent it. Otherwise the system cause
> > mysterious hang-up and/or OOM Killer invokation.
> 
> And that's exactly the promises xfsbufd gives.  It writes out dirty
> metadata buffers and will free lots of memory if you kick it. 

if xfsbufd doesn't only write out dirty data but also drop page,
I agree you. 


