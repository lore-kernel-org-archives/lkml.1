Return-Path: <linux-kernel-owner+w=401wt.eu-S1761864AbXHWJ0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761864AbXHWJ0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 05:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761468AbXHWJ0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 05:26:34 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52688 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761412AbXHWJ0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 05:26:33 -0400
Date: Thu, 23 Aug 2007 02:26:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Alexey Dobriyan <adobriyan@openvz.org>
Subject: Re: [BUG] 2.6.23-rc3-mm1 Kernel panic - not syncing: Can't create
 pid_1 cachep
Message-Id: <20070823022611.460cb326.akpm@linux-foundation.org>
In-Reply-To: <46CD4F7B.1090802@linux.vnet.ibm.com>
References: <46CC3F94.4050609@linux.vnet.ibm.com>
	<46CC4AD2.2080306@openvz.org>
	<46CCA33E.5060905@linux.vnet.ibm.com>
	<46CD4F7B.1090802@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Aug 2007 14:42:27 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> Andrew after setting CONFIG_SLUB=n and CONFIG_SLAB, it hits
> a kernel Bug, and attaching the config file.
> 
> Memory: 32479392k/33554432k available (2627k kernel code, 280028k 
> reserved, 1274k data, 220k init, 31842304k highmem)
> virtual kernel memory layout:
>     fixmap  : 0xffe1a000 - 0xfffff000   (1940 kB)
>     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
>     vmalloc : 0xf8800000 - 0xffbfe000   ( 115 MB)
>     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
>       .init : 0xc13d6000 - 0xc140d000   ( 220 kB)
>       .data : 0xc1290e65 - 0xc13cf758   (1274 kB)
>       .text : 0xc1000000 - 0xc1290e65   (2627 kB)
> Checking if this processor honours the WP bit even in supervisor mode... Ok.
> Calibrating delay using timer specific routine.. 1401.57 BogoMIPS 
> (lpj=2803147)
> ------------[ cut here ]------------
> kernel BUG at mm/slab.c:3320!
> invalid opcode: 0000 [#1] SMP
> kernel BUG at mm/slab.c:3320!

static void *____cache_alloc_node(struct kmem_cache *cachep, gfp_t flags,
                                int nodeid)
{
        struct list_head *entry;
        struct slab *slabp;
        struct kmem_list3 *l3;
        void *obj;
        int x;

        l3 = cachep->nodelists[nodeid];
        BUG_ON(!l3);

I _looks_ like an ordering problem, but slab is all set up by then.

Strange.
