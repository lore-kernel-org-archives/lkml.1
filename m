Return-Path: <linux-kernel-owner+w=401wt.eu-S1754747AbXEHTgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbXEHTgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 15:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754638AbXEHTge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 15:36:34 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48139 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754114AbXEHTgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 15:36:33 -0400
Date: Tue, 8 May 2007 12:35:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Frederik Deweerdt <deweerdt@free.fr>
Cc: linux-kernel@vger.kernel.org, jbeulich@novell.com, ak@suse.de
Subject: Re: kmem_cache_init failure (was Re: 2.6.21-mm1)
Message-Id: <20070508123555.dfb7d5bb.akpm@linux-foundation.org>
In-Reply-To: <20070508172233.GA11683@slug>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>
	<20070508172233.GA11683@slug>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007 19:22:33 +0200
Frederik Deweerdt <deweerdt@free.fr> wrote:

> On Sat, May 05, 2007 at 01:49:55AM -0700, Andrew Morton wrote:
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm1/
> > 
> Hi all,
> 
> My computer fails early at boot with a stack along the lines of:
> 
> kmem_cache_zalloc
> kmem_cache_create
> kmem_cache_init
> start_kernel
> 
> eip is at cache_calloc_refill+0x3e1 which is the 
> slabp->colouroff = colouroff; in alloc_slabmgmt()
> 
> I've bisected it down to the x86_64-mm-cpa-kerneltext.patch and the 
> 
> +       if (!pte_present(*kpte))
> +               return 0;
>
> part in particular. Dotconfig and cpuinfo are available at
> http://fdeweerdt.free.fr/kmem_prob/.  Any ideas?

Thanks for working that out - it helps heaps.

x86_64-mm-cpa-kerneltext.patch seems to have been dropped from Andi's tree.
It might come back, so please let's keep an eye out for that.

