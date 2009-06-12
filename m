Return-Path: <linux-kernel-owner+w=401wt.eu-S1764074AbZFLBaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764074AbZFLBaA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 21:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761229AbZFLB3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 21:29:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:51226 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757212AbZFLB3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 21:29:52 -0400
Subject: Re: slab: setup allocators earlier in the boot sequence
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: git-commits-head@vger.kernel.org
In-Reply-To: <200906111959.n5BJxFj9021205@hera.kernel.org>
References: <200906111959.n5BJxFj9021205@hera.kernel.org>
Content-Type: text/plain
Date: Fri, 12 Jun 2009 11:29:52 +1000
Message-Id: <1244770192.7172.3.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-11 at 19:59 +0000, Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/linus/83b519e8b9572c319c8e0c615ee5dd7272856090
> Commit:     83b519e8b9572c319c8e0c615ee5dd7272856090
> Parent:     c91c4773b334d4d3a6d44626dc2a558ad97b86f3
> Author:     Pekka Enberg <penberg@cs.helsinki.fi>
> AuthorDate: Wed Jun 10 19:40:04 2009 +0300
> Committer:  Pekka Enberg <penberg@cs.helsinki.fi>
> CommitDate: Thu Jun 11 19:15:56 2009 +0300
> 
>     slab: setup allocators earlier in the boot sequence
>     
>     This patch makes kmalloc() available earlier in the boot sequence so we can get
>     rid of some bootmem allocations. The bulk of the changes are due to
>     kmem_cache_init() being called with interrupts disabled which requires some
>     changes to allocator boostrap code.
>     
>     Note: 32-bit x86 does WP protect test in mem_init() so we must setup traps
>     before we call mem_init() during boot as reported by Ingo Molnar:

This seem to explode in various places on powerpc :-(

It would have been nice if we had enough advance warning to actually fix
our archs too ... I had no idea it was going to be merged that soon. I
did plan to dig into this at some stage but that was too soon. Maybe it
should have been a CONFIG option for a couple of -rc's ?

But yeah, of course, only x86 matters right ? We can break everybody
else and fuck up bisection just for fun...

Cheers,
Ben.


