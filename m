Return-Path: <linux-kernel-owner+w=401wt.eu-S1763573AbXERSP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763573AbXERSP2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 14:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763974AbXERSO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 14:14:28 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58914 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763442AbXERSO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 14:14:26 -0400
Date: Fri, 18 May 2007 11:14:26 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <npiggin@suse.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-arch@vger.kernel.org
Subject: Re: [rfc] increase struct page size?!
In-Reply-To: <20070518040854.GA15654@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0705181112250.11881@schroedinger.engr.sgi.com>
References: <20070518040854.GA15654@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2007, Nick Piggin wrote:

> However we don't have to let those 8 bytes go to waste: we can use them
> to store the virtual address of the page, which kind of makes sense for
> 64-bit, because they can likely to use complicated memory models.

That is not a valid consideration anymore. There is virtual memmap update 
pending with the sparsemem folks that will simplify things.

> Many batch operations on struct page are completely random, and as such, I
> think it is better if each struct page fits completely into a single
> cacheline even if it means being slightly larger.

Right. That would simplify the calculations.
 
> Don't let this space go to waste though, we can use page->virtual in order
> to optimise page_address operations.

page->virtual is a benefit if the page is cache hot. Otherwise it may 
cause a useless lookup.

I wonder if there are other uses for the free space?

