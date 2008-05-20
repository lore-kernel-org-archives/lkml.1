Return-Path: <linux-kernel-owner+w=401wt.eu-S1763712AbYETTaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763712AbYETTaW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 15:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755062AbYETTaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 15:30:08 -0400
Received: from brick.kernel.dk ([87.55.233.238]:17536 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754910AbYETTaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 15:30:06 -0400
Date: Tue, 20 May 2008 21:29:59 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] block: blk_queue_bounce_limits can actually sleep
Message-ID: <20080520192958.GW22369@kernel.dk>
References: <20080519202409.6d1055be@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080519202409.6d1055be@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19 2008, Arjan van de Ven wrote:
> From: Arjan van de Ven <arjan@linux.intel.com>
> Subject: [PATCH] block: blk_queue_bounce_limits can actually sleep
> 
> blk_queue_bounce_limit can call init_emergency_isa_pool, which
> does sleeping allocations... document it as such by adding
> might_sleep() to the driver

Isn't that superflous, as mempool_create() -> kmalloc(..., __GFP_WAIT)
ends up spewing that warning anyway?

-- 
Jens Axboe

