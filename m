Return-Path: <linux-kernel-owner+w=401wt.eu-S1755274AbYG1KE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbYG1KE6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 06:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbYG1KEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 06:04:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:45747 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbYG1KEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 06:04:50 -0400
Subject: Re: page swap allocation error/failure in 2.6.25
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Samad <alex@samad.com.au>
Cc: linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
       Mel Gorman <mel@skynet.ie>
In-Reply-To: <20080727060701.GA7157@samad.com.au>
References: <20080725072015.GA17688@samad.com.au>
	 <1216971601.7257.345.camel@twins>  <20080727060701.GA7157@samad.com.au>
Content-Type: text/plain
Date: Mon, 28 Jul 2008 12:04:47 +0200
Message-Id: <1217239487.6331.24.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-07-27 at 16:07 +1000, Alex Samad wrote:
> On Fri, Jul 25, 2008 at 09:40:01AM +0200, Peter Zijlstra wrote:
> > On Fri, 2008-07-25 at 17:20 +1000, Alex Samad wrote:
> > > Hi
> 
> [snip]
> 
> > 
> > 
> > Its harmless if it happens sporadically. 
> > 
> > Atomic order 2 allocations are just bound to go wrong under pressure.
> can you point me to any doco that explains this ?

An order 2 allocation means allocating 1<<2 or 4 physically contiguous
pages. Atomic allocation means not being able to sleep.

Now if the free page lists don't have any order 2 pages available due to
fragmentation there is currently nothing we can do about it.

I've been meaning to try and play with 'atomic' page migration to try
and assemble a higher order page on demand with something like memory
compaction.

But its never managed to get high enough on the todo list..

