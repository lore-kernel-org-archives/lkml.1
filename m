Return-Path: <linux-kernel-owner+w=401wt.eu-S966796AbXEHRXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966796AbXEHRXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 13:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966392AbXEHRXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 13:23:46 -0400
Received: from qb-out-0506.google.com ([72.14.204.235]:65081 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965796AbXEHRXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 13:23:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=QgxYHiVqW7yqD9cU1+c3VO8xD+qJDl0X0SVi1NbQkKpigsyQuGKzsJgwjgK2ChYaMIA+tiBC7RKopE8D5jKqbeiijsidwe9ivDsCljpI5JaqQ6d36kfh0nQTQXvPxyBtFS/SL7Gi7UyUgw8HNEeKJxao3JjcTUeX5x9uebxsPK4=
Date: Tue, 8 May 2007 19:22:33 +0200
From: Frederik Deweerdt <deweerdt@free.fr>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, jbeulich@novell.com, ak@suse.de
Subject: kmem_cache_init failure (was Re: 2.6.21-mm1)
Message-ID: <20070508172233.GA11683@slug>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070505014955.8f3990b5.akpm@linux-foundation.org>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2007 at 01:49:55AM -0700, Andrew Morton wrote:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm1/
> 
Hi all,

My computer fails early at boot with a stack along the lines of:

kmem_cache_zalloc
kmem_cache_create
kmem_cache_init
start_kernel

eip is at cache_calloc_refill+0x3e1 which is the 
slabp->colouroff = colouroff; in alloc_slabmgmt()

I've bisected it down to the x86_64-mm-cpa-kerneltext.patch and the 

+       if (!pte_present(*kpte))
+               return 0;

part in particular. Dotconfig and cpuinfo are available at
http://fdeweerdt.free.fr/kmem_prob/.  Any ideas?

Regards,
Frederik
