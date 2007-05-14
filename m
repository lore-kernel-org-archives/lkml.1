Return-Path: <linux-kernel-owner+w=401wt.eu-S1758365AbXENTqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758365AbXENTqA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 15:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754916AbXENTpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 15:45:51 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34035 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754830AbXENTpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 15:45:50 -0400
Date: Mon, 14 May 2007 12:44:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Thomas Graf <tgraf@suug.ch>,
       David Miller <davem@davemloft.net>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 0/5] make slab gfp fair
Message-Id: <20070514124451.c868c4c0.akpm@linux-foundation.org>
In-Reply-To: <20070514161224.GC11115@waste.org>
References: <20070514131904.440041502@chello.nl>
	<Pine.LNX.4.64.0705140852150.10442@schroedinger.engr.sgi.com>
	<20070514161224.GC11115@waste.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2007 11:12:24 -0500
Matt Mackall <mpm@selenic.com> wrote:

> If I understand this correctly:
> 
> privileged thread                      unprivileged greedy process
> kmem_cache_alloc(...)
>    adds new slab page from lowmem pool
> do_io()
>                                        kmem_cache_alloc(...)
>                                        kmem_cache_alloc(...)
>                                        kmem_cache_alloc(...)
>                                        kmem_cache_alloc(...)
>                                        kmem_cache_alloc(...)
>                                        ...
>                                           eats it all
> kmem_cache_alloc(...) -> ENOMEM
>    who ate my donuts?!

Yes, that's my understanding also.

I can see why it's a problem in theory, but I don't think Peter has yet
revealed to us why it's a problem in practice.  I got all excited when
Christoph asked "I am not sure what the point of all of this is.", but
Peter cunningly avoided answering that ;)

What observed problem is being fixed here?
