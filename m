Return-Path: <linux-kernel-owner+w=401wt.eu-S1758597AbYBDXrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597AbYBDXrp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 18:47:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756218AbYBDXrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 18:47:37 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57920 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754133AbYBDXrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 18:47:37 -0500
Date: Mon, 4 Feb 2008 15:47:36 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [git pull] SLUB updates for 2.6.25
In-Reply-To: <200802051010.49372.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0802041542570.4774@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0802041206190.3241@schroedinger.engr.sgi.com>
 <20080204142845.4c734f94.akpm@linux-foundation.org>
 <20080204143053.9fac9eac.akpm@linux-foundation.org> <200802051010.49372.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008, Nick Piggin wrote:

> > erk, sorry, I misremembered.   I was about to merge all the patches we
> > weren't going to merge.  oops.
> 
> While you're there, can you drop the patch(es?) I commented on
> and didn't get an answer to. Like the ones that open code their
> own locking primitives and do risky looking things with barriers
> to boot...

That patch will be moved to a special archive for 
microbenchmarks. It shows the same issues like the __unlock patch.
 
> Also, WRT this one:
> slub-use-non-atomic-bit-unlock.patch
> 
> This is strange that it is unwanted. Avoiding atomic operations
> is a pretty good idea. The fact that it appears to be slower on
> some microbenchmark on some architecture IMO either means that
> their __clear_bit_unlock or the CPU isn't implemented so well...

Its slower on x86_64 and that is a pretty important arch. So 
I am to defer this until we have analyzed the situation some more. Could 
there be some effect of atomic ops on the speed with which a cacheline is 
released?

