Return-Path: <linux-kernel-owner+w=401wt.eu-S1030814AbXCTAz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030814AbXCTAz3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 20:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030820AbXCTAz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 20:55:28 -0400
Received: from smtp.osdl.org ([65.172.181.24]:37652 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030819AbXCTAz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 20:55:27 -0400
Date: Mon, 19 Mar 2007 17:55:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [QUICKLIST 1/5] Quicklists for page table pages V3
Message-Id: <20070319175524.812b2f5d.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703191718220.13927@schroedinger.engr.sgi.com>
References: <20070319233716.13775.45569.sendpatchset@schroedinger.engr.sgi.com>
	<20070319165329.b5830789.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0703191655190.13879@schroedinger.engr.sgi.com>
	<20070319170741.5a24af4c.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0703191718220.13927@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007 17:44:28 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> On Mon, 19 Mar 2007, Andrew Morton wrote:
> 
> > Please provide proof that quicklists are superior to simply going direct to
> > the page allocator for these pages.
> 
> See the patch. We are only touching 2 cachelines instead of 32. So even 
> without considering the page allocator overhead and the slab allocator 
> overhead (which will make the situation even better) its superior.

That's not proof, it is handwaving.  I could wave right back at you and
claim that the benefit from returning a cache-hot pte page back to the page
allocator for reuse exceeds the benefit which you waved at me above.

You may well be right, but nothing is proven, afaict.

> > > I doubt it. The zeroing is a by product of our way of serializing pte 
> > > handling. Its going to be difficult to change that.
> > 
> > Nick didn't think so, and I don't see the problem either.
> 
> You do not think that our current way of handling ptes is okay? If we do 
> not zero the ptes then we need to separate munmap from process shutdown.

Yep.  It's possible that process shutdown is a sufficiently common and
costly special-case for it to be worth special-casing.

> > We'll save on some bus traffic by avoiding the writeback, but how much
> > effect that will have we don't know.  Presumably little.
> 
> The advantage of the quicklists is that it does not require a rework of 
> the pte serialization.

No, these are unrelated.  We can get pte pages from the page allocator and
zero them without touching the munmap handling.

But it's possible that if we _were_ to optimise the munmap handling as
suggested, the end result would be superior.

