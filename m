Return-Path: <linux-kernel-owner+w=401wt.eu-S932247AbXDIS4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247AbXDIS4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 14:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932263AbXDIS4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 14:56:40 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53912 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932247AbXDIS4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 14:56:40 -0400
Date: Mon, 9 Apr 2007 11:56:39 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <ak@suse.de>
cc: akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [QUICKLIST 3/4] Quicklist support for x86_64
In-Reply-To: <200704092053.05590.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0704091153480.8986@schroedinger.engr.sgi.com>
References: <20070409182509.8559.33823.sendpatchset@schroedinger.engr.sgi.com>
 <200704092049.34317.ak@suse.de> <Pine.LNX.4.64.0704091150260.8783@schroedinger.engr.sgi.com>
 <200704092053.05590.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Apr 2007, Andi Kleen wrote:

> > Otherwise you will leak pages to the page allocator before the tlb flush 
> > occurred.
> 
> I don't get it sorry. Can you please explain in more detail?

On process teardown pages are freed via the tlb mechanism. That mechanism 
guarantees that TLBs for pages are flushed before they can be reused. We 
tie into that and put pages on quicklists. The quicklists are trimmed
after the TLB flush.

If a shrinker would indepedently free pages from the quicklists then this 
mechanism would no longer work and pages that still have a valid TLB for 
one process may be reused by other processes.


