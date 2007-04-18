Return-Path: <linux-kernel-owner+w=401wt.eu-S1422924AbXDRMIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422924AbXDRMIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 08:08:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422925AbXDRMIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 08:08:07 -0400
Received: from smtp24.orange.fr ([193.252.22.25]:27035 "EHLO smtp24.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422924AbXDRMIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 08:08:05 -0400
X-ME-UUID: 20070418120803246.3C46C1C0008B@mwinf2433.orange.fr
Date: Wed, 18 Apr 2007 14:07:52 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Pavel Emelianov <xemul@sw.ru>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Kirill Korotaev <dev@openvz.org>, linux-mm@kvack.org
Subject: Re: [PATCH] Show slab memory usage on OOM and SysRq-M
Message-Id: <20070418140752.02084f34.dada1@cosmosbay.com>
In-Reply-To: <Pine.LNX.4.64.0704180915520.11160@sbz-30.cs.Helsinki.FI>
References: <4624C3C1.9040709@sw.ru>
	<84144f020704170622h2b16f0f6m47ffdbb3b5686758@mail.gmail.com>
	<20070417171213.e3cbc260.dada1@cosmosbay.com>
	<Pine.LNX.4.64.0704180915520.11160@sbz-30.cs.Helsinki.FI>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2007 09:17:19 +0300 (EEST)
Pekka J Enberg <penberg@cs.helsinki.fi> wrote:

> On Tue, 17 Apr 2007, Eric Dumazet wrote:
> > This nr_pages should be in struct kmem_list3, not in struct kmem_cache, 
> > or else you defeat NUMA optimizations if touching a field in kmem_cache 
> > at kmem_getpages()/kmem_freepages() time.
> 
> We already touch ->flags, ->gfpflags, and ->gfporder in kmem_getpages(). 
> Sorry for my ignorance, but how is this different?
> 

Those fields are read. Thats OK, because several CPUS might share all those without problem.

But modifying one field in kmem_cache would invalidate one cache line for all cpus that would have to reload it later.

This is what we call "false sharing" or cache line ping pongs


