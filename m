Return-Path: <linux-kernel-owner+w=401wt.eu-S1758920AbXFZSTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920AbXFZSTe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 14:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756972AbXFZST2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 14:19:28 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:44351 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756075AbXFZST1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 14:19:27 -0400
Date: Tue, 26 Jun 2007 11:19:26 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Pekka Enberg <penberg@cs.helsinki.fi>, suresh.b.siddha@intel.com
Subject: Re: [patch 12/26] SLUB: Slab defragmentation core
In-Reply-To: <20070626011831.181d7a6a.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706261114320.18010@schroedinger.engr.sgi.com>
References: <20070618095838.238615343@sgi.com> <20070618095916.297690463@sgi.com>
 <20070626011831.181d7a6a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007, Andrew Morton wrote:

> > 	No slab operations may be performed in get_reference(). Interrupts
> 
> s/get_reference/get/, yes?

Correct.

> (What's the smallest sized object slub will create?  4 bytes?)

__alignof__(unsigned long long)

> To hold off a concurrent free while defragging, the code relies upon
> slab_lock() on the current page, yes?

Right.
 
> But slab_lock() isn't taken for slabs whose objects are larger than 
> PAGE_SIZE. How's that handled?

slab lock is always taken. How did you get that idea?

> Overall: looks good.  It'd be nice to get a buffer_head shrinker in place,
> see how that goes from a proof-of-concept POV.

Ok.

> How much testing has been done on this code, and of what form, and with
> what results?

I posted them in the intro of the last full post and then Michael 
Piotrowski did some stress tests.

See http://marc.info/?l=linux-mm&m=118125373320855&w=2

