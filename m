Return-Path: <linux-kernel-owner+w=401wt.eu-S1759407AbXEQSBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759407AbXEQSBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 14:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754956AbXEQSBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 14:01:04 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46931 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754439AbXEQSBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 14:01:02 -0400
Date: Thu, 17 May 2007 11:01:01 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Thomas Graf <tgraf@suug.ch>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 0/5] make slab gfp fair
In-Reply-To: <1179424430.2925.7.camel@lappy>
Message-ID: <Pine.LNX.4.64.0705171059340.18085@schroedinger.engr.sgi.com>
References: <1179350433.2912.66.camel@lappy> 
 <Pine.LNX.4.64.0705161435110.11642@schroedinger.engr.sgi.com> 
 <1179386921.27354.29.camel@twins>  <Pine.LNX.4.64.0705171029500.17245@schroedinger.engr.sgi.com>
 <1179424430.2925.7.camel@lappy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007, Peter Zijlstra wrote:

> > > Its about ensuring ALLOC_NO_WATERMARKS memory only reaches PF_MEMALLOC
> > > processes, not joe random's pi calculator.
> > 
> > Watermarks are per zone?
> 
> Yes, but the page allocator might address multiple zones in order to
> obtain a page.

And then again it may not because the allocation is contrained to a 
particular node,a NORMAL zone or a DMA zone. One zone way be below the 
watermark and another may not. Different allocations may be allowed to 
tap into various zones for various reasons.

