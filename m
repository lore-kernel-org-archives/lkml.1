Return-Path: <linux-kernel-owner+w=401wt.eu-S1759370AbYLLRRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759370AbYLLRRu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 12:17:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757130AbYLLRRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 12:17:43 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:55127 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757104AbYLLRRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 12:17:42 -0500
Subject: Re: [PATCH 07/15] kmemleak: Add memleak_alloc callback from
	alloc_large_system_hash
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
In-Reply-To: <1229101452.15045.60.camel@pc1117.cambridge.arm.com>
References: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>
	 <20081210182732.30323.39834.stgit@pc1117.cambridge.arm.com>
	 <1228935860.9737.98.camel@nimitz>
	 <1228989052.332.12.camel@pc1117.cambridge.arm.com>
	 <1229016618.17206.2.camel@nimitz>
	 <1229017098.332.45.camel@pc1117.cambridge.arm.com>
	 <1229017506.17206.7.camel@nimitz>
	 <84144f020812111147h77587bd2t9dbe03f132cb1153@mail.gmail.com>
	 <1229101452.15045.60.camel@pc1117.cambridge.arm.com>
Content-Type: text/plain
Date: Fri, 12 Dec 2008 09:17:39 -0800
Message-Id: <1229102259.17206.58.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-12-12 at 17:04 +0000, Catalin Marinas wrote:
> It looks to me like alloc_large_system_hash() could also be called at
> some later point and it may even invoke __vmalloc() if hashdist is set.
> So I would prefer not to introduce another hook and additional if's to
> know which one to call. BTW, I think the callback should actually be (to
> avoid duplicating the vmalloc call, with proper comment):
> 
>         if (!hashdist)
>                 memleak_alloc(table, size, 1, GFP_ATOMIC);

Does memleak_alloc() detect if it gets called twice on the same memory?
Also, is alloc_large_system_hash() contained in the tests that you can
compile for kmemleak?

-- Dave

