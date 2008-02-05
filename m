Return-Path: <linux-kernel-owner+w=401wt.eu-S1757620AbYBEAdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757620AbYBEAdI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 19:33:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758663AbYBEAcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 19:32:52 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59056 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758095AbYBEAcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 19:32:51 -0500
Date: Mon, 4 Feb 2008 16:32:50 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: willy@linux.intel.com, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [git pull] SLUB updates for 2.6.25
In-Reply-To: <200802051105.12194.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0802041629290.5057@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0802041206190.3241@schroedinger.engr.sgi.com>
 <200802051010.49372.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0802041542570.4774@schroedinger.engr.sgi.com>
 <200802051105.12194.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008, Nick Piggin wrote:

> Ok. But the approach is just not so good. If you _really_ need something
> like that and it is a win over the regular non-atomic unlock, then you
> just have to implement it as a generic locking / atomic operation and
> allow all architectures to implement the optimal (and correct) memory
> barriers.

Assuming this really gives a benefit on several benchmarks then we need 
to think about how to do this some more. Its a rather strange form of 
locking.
 
Basically you lock the page with a single atomic operation that sets 
PageLocked and retrieves the page flags. Then we shovel the page state 
around a couple of functions in a register and finally store the page 
state back which at the same time unlocks the page. So two memory 
references with one of them being atomic with none in between. We have 
nothing that can do something like that right now.

