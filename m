Return-Path: <linux-kernel-owner+w=401wt.eu-S1757190AbYLKRap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190AbYLKRap (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 12:30:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756606AbYLKRah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 12:30:37 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37945 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755954AbYLKRag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 12:30:36 -0500
Subject: Re: [PATCH 07/15] kmemleak: Add memleak_alloc callback from
	alloc_large_system_hash
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1228989052.332.12.camel@pc1117.cambridge.arm.com>
References: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>
	 <20081210182732.30323.39834.stgit@pc1117.cambridge.arm.com>
	 <1228935860.9737.98.camel@nimitz>
	 <1228989052.332.12.camel@pc1117.cambridge.arm.com>
Content-Type: text/plain
Date: Thu, 11 Dec 2008 09:30:18 -0800
Message-Id: <1229016618.17206.2.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-12-11 at 09:50 +0000, Catalin Marinas wrote:
> > Since alloc_large_system_hash() is using bootmem (and is called early),
> > I'm a little surprised that it is OK to call into memleak_alloc() which
> > uses kmem_cache_alloc().  Is the slab even set up at this point?
> 
> It doesn't need to be. Early callbacks like this are logged by kmemleak
> in a buffer and properly registered once the slab allocator is fully
> initialised (slab initialisation needs to allocate some memory for
> itself as well).

Ahh, thanks for the clarification.  Could you add something to the code
to this effect?

-- Dave

