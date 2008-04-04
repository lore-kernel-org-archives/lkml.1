Return-Path: <linux-kernel-owner+w=401wt.eu-S1758186AbYDDQUC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186AbYDDQUC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 12:20:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755181AbYDDQTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 12:19:54 -0400
Received: from [194.117.236.238] ([194.117.236.238]:56343 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754991AbYDDQTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 12:19:53 -0400
Date: Fri, 4 Apr 2008 19:19:43 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] relay: add buffer-only functionality, allowing for
 early kernel tracing
Message-ID: <20080404191943.2d708cbf@linux360.ro>
In-Reply-To: <20080404160623.GC32126@Krystal>
References: <20080404183303.2e239a20@linux360.ro>
	<20080404160623.GC32126@Krystal>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Apr 2008 12:06:23 -0400
Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:

> I like this :) But could we trace event sooner if we did not depend on
> vmalloc to allocate the buffers ?
> 
> I am thinking of receiving a kernel parameter that would reserve a
> buffer in the linear kernel mapping (kmalloc ?), or to compile-in a
> static buffer, which could be used by relay instead of the vmalloc'd
> buffer. That would permit to trace the memory allocator and some other
> very early stuff. Basically, relay would have it's "memory pool" to
> manage and would do its allocations from this fixed buffer. No free
> would be required.
> 
> Mathieu

Sure. I'm doing this as part of my GSoC application (well, I haven't
been accepted yet). I had also proposed this to Pekka Enberg, my
mentor, but he was reluctant to hack the relay code more invasively. Now
that you agree with this, I'll work on it.

kmalloc() doesn't work before kmem_cache_init() and relay code uses
kmalloc(), not vmalloc(), IIRC.

I would go another way. Have the relay client call __get_free_pages()
or similar function, allocate the buffer and pass it on to a variant of
relay_open(), let's name it relay_early_open(). __get_free_pages() can
be used before kmem_cache_init() as far as I know. No free is required,
since early tracing code implies it's built into the kernel and not as
a module. What do you say?

Will you merge this or wait until I finish the very early tracing stuff?

Cheers,
Eduard
