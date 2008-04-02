Return-Path: <linux-kernel-owner+w=401wt.eu-S1756409AbYDBNoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409AbYDBNoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 09:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754220AbYDBNoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 09:44:01 -0400
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:35228 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939AbYDBNoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 09:44:00 -0400
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jens Axboe <jens.axboe@oracle.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: kmemcheck caught read from freed memory (cfq_free_io_context)
References: <20080402105539.GA5610@linux.vnet.ibm.com>
	<84144f020804020401j4e5863dcofd16662baa54574@mail.gmail.com>
	<20080402110718.GU12774@kernel.dk> <1207134536.8514.773.camel@twins>
	<20080402111422.GW12774@kernel.dk> <1207135212.8514.782.camel@twins>
	<20080402113258.GY12774@kernel.dk> <1207136230.8514.791.camel@twins>
	<20080402114243.GZ12774@kernel.dk> <1207136867.8514.796.camel@twins>
	<20080402115337.GD12774@kernel.dk> <1207138422.8514.799.camel@twins>
From: Andi Kleen <andi@firstfloor.org>
Date: 02 Apr 2008 15:43:57 +0200
In-Reply-To: <1207138422.8514.799.camel@twins>
Message-ID: <878wzwe5ia.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 Apr 2008 13:37:16.0335 (UTC) FILETIME=[AA66ABF0:01C894C6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <a.p.zijlstra@chello.nl> writes:
> 
> Ok I gave it a go, how bad is this text?

Should be also in the kernel doc description of kmem_cache_create(), so it 
appears in manpages etc.

-Andi
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index f950a89..e049ddc 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -25,6 +25,32 @@
>  #define SLAB_CACHE_DMA		0x00004000UL	/* Use GFP_DMA memory */
>  #define SLAB_STORE_USER		0x00010000UL	/* DEBUG: Store the last owner for bug hunting */
>  #define SLAB_PANIC		0x00040000UL	/* Panic if kmem_cache_create() fails */
> +/*
> + * SLAB_DESTROY_BY_RCU - **WARNING** READ THIS!
