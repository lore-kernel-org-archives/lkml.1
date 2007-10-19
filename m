Return-Path: <linux-kernel-owner+w=401wt.eu-S1763569AbXJSBVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763569AbXJSBVM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 21:21:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754764AbXJSBVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 21:21:03 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53174 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755772AbXJSBVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 21:21:01 -0400
Date: Thu, 18 Oct 2007 18:21:00 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org, linux-mm@kvack.org
Subject: Re: SLUB: Avoid atomic operation for slab_unlock
In-Reply-To: <200710190949.01019.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0710181817380.4194@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0710181514310.3584@schroedinger.engr.sgi.com>
 <200710190949.01019.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007, Nick Piggin wrote:

> Ah, thanks, but can we just use my earlier patch that does the
> proper __bit_spin_unlock which is provided by
> bit_spin_lock-use-lock-bitops.patch

Ok.

> This primitive should have a better chance at being correct, and
> also potentially be more optimised for each architecture (it
> only has to provide release consistency).

Yes that is what I attempted to do with the write barrier. To my knowledge 
there are no reads that could bleed out and I wanted to avoid a full fence 
instruction there.

> I have attached the patch here just for reference, but actually
> I am submitting it properly as part of a patch series today, now
> that the base bit lock patches have been sent upstream.

Good. Andrew: Drop my patch when this goes in.
