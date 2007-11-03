Return-Path: <linux-kernel-owner+w=401wt.eu-S1757944AbXKCS1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944AbXKCS1G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 14:27:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755174AbXKCS04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 14:26:56 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48849 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754867AbXKCS0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 14:26:55 -0400
Date: Sat, 3 Nov 2007 11:26:55 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Hugh Dickins <hugh@veritas.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] slub: fix Objects count
In-Reply-To: <Pine.LNX.4.64.0711031711080.10266@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0711031125090.5395@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0711031708040.10266@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0711031711080.10266@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Nov 2007, Hugh Dickins wrote:

> The count of active Objects shown by Slub's slabinfo is too approximate,
> because each cpu slab is counted as all in use, even when lots are free.
> That makes tracing leaks harder than it need be.

True but that is the way it is for performance reasons.

> Add a free count into kmem_cache_cpu (which doesn't enlarge it on 64-bit),
> to keep that count in the hot and dirty per-cpu cacheline.

Adds to much overhead to the fast paths and will make the current 
optimizations in mm impossible.

