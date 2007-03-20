Return-Path: <linux-kernel-owner+w=401wt.eu-S1030818AbXCTAoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030818AbXCTAoa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 20:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030802AbXCTAoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 20:44:30 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:59969 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030818AbXCTAo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 20:44:29 -0400
Date: Mon, 19 Mar 2007 17:44:28 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-mm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [QUICKLIST 1/5] Quicklists for page table pages V3
In-Reply-To: <20070319170741.5a24af4c.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703191718220.13927@schroedinger.engr.sgi.com>
References: <20070319233716.13775.45569.sendpatchset@schroedinger.engr.sgi.com>
 <20070319165329.b5830789.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0703191655190.13879@schroedinger.engr.sgi.com>
 <20070319170741.5a24af4c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007, Andrew Morton wrote:

> Please provide proof that quicklists are superior to simply going direct to
> the page allocator for these pages.

See the patch. We are only touching 2 cachelines instead of 32. So even 
without considering the page allocator overhead and the slab allocator 
overhead (which will make the situation even better) its superior.

> > I doubt it. The zeroing is a by product of our way of serializing pte 
> > handling. Its going to be difficult to change that.
> 
> Nick didn't think so, and I don't see the problem either.

You do not think that our current way of handling ptes is okay? If we do 
not zero the ptes then we need to separate munmap from process shutdown.

> We'll save on some bus traffic by avoiding the writeback, but how much
> effect that will have we don't know.  Presumably little.

The advantage of the quicklists is that it does not require a rework of 
the pte serialization.

