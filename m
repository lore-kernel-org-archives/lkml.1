Return-Path: <linux-kernel-owner+w=401wt.eu-S1765274AbXHTUcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765274AbXHTUcx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 16:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764164AbXHTU1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 16:27:33 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:51998 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764517AbXHTU1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 16:27:32 -0400
Date: Mon, 20 Aug 2007 13:27:30 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Pavel Machek <pavel@ucw.cz>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       dkegel@google.com, David Miller <davem@davemloft.net>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [RFC 2/9] Use NOMEMALLOC reclaim to allow reclaim if PF_MEMALLOC
 is set
In-Reply-To: <1187641056.5337.32.camel@lappy>
Message-ID: <Pine.LNX.4.64.0708201323590.30053@schroedinger.engr.sgi.com>
References: <20070814153021.446917377@sgi.com>  <20070814153501.305923060@sgi.com>
 <20070818071035.GA4667@ucw.cz>  <Pine.LNX.4.64.0708201158270.28863@schroedinger.engr.sgi.com>
 <1187641056.5337.32.camel@lappy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Aug 2007, Peter Zijlstra wrote:

> > Plus the same issue can happen today. Writes are usually not completed 
> > during reclaim. If the writes are sufficiently deferred then you have the 
> > same issue now.
> 
> Once we have initiated (disk) writeout we do not need more memory to
> complete it, all we need to do is wait for the completion interrupt.

We cannot reclaim the page as long as the I/O is not complete. If you 
have too many anonymous pages and the rest of memory is dirty then you can 
get into OOM scenarios even without this patch.

> Networking is different here in that an unbounded amount of net traffic
> needs to be processed in order to find the completion event.

Its not that different. Pages are pinned during writeout from reclaim and 
it is not clear when the write will complete. There are no bounds that I 
know in reclaim for the writeback of dirty anonymous pages.

But some throttling function like for dirty pages is likely needed for 
network traffic.


