Return-Path: <linux-kernel-owner+w=401wt.eu-S1757206AbZBDQMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206AbZBDQMA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 11:12:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbZBDQLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 11:11:51 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:45320 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752684AbZBDQLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 11:11:51 -0500
Date: Wed, 4 Feb 2009 10:49:46 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Mel Gorman <mel@csn.ul.ie>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: [patch] SLQB slab allocator (try 2)
In-Reply-To: <200902032307.09025.nickpiggin@yahoo.com.au>
Message-ID: <alpine.DEB.1.10.0902041049090.19633@qirst.com>
References: <20090123154653.GA14517@wotan.suse.de> <200902032250.55968.nickpiggin@yahoo.com.au> <20090203120139.GM9840@csn.ul.ie> <200902032307.09025.nickpiggin@yahoo.com.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Feb 2009, Nick Piggin wrote:

> > so the max_order is inclusive not exclusive. This will force the order-0
> > allocations I think you are looking for.
>
> Well, but in the case of really bad internal fragmentation in the page,
> SLAB will do order-1 allocations even if it doesn't strictly need to.
> Probably this isn't a huge deal, but I think if we do slub_min_objects=1,
> then SLUB won't care about number of objects per page, and slub_max_order=1
> will mean it stops caring about fragmentation after order-1. I think. Which
> would be pretty close to SLAB (depending on exactly how much fragmentation
> it cares about).

slub_max_order=0 will fore all possible slabs to order 0. This means that
some slabs that SLAB will run as order 1 will be order 0 under SLUB.
