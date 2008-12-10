Return-Path: <linux-kernel-owner+w=401wt.eu-S1757256AbYLJTEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256AbYLJTEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 14:04:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753648AbYLJTE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 14:04:27 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:46611 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431AbYLJTE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 14:04:26 -0500
Subject: Re: [PATCH 07/15] kmemleak: Add memleak_alloc callback from
	alloc_large_system_hash
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081210182732.30323.39834.stgit@pc1117.cambridge.arm.com>
References: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>
	 <20081210182732.30323.39834.stgit@pc1117.cambridge.arm.com>
Content-Type: text/plain
Date: Wed, 10 Dec 2008 11:04:20 -0800
Message-Id: <1228935860.9737.98.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-10 at 18:27 +0000, Catalin Marinas wrote:
> 
> @@ -4570,6 +4571,8 @@ void *__init alloc_large_system_hash(const char *tablename,
>         if (_hash_mask)
>                 *_hash_mask = (1 << log2qty) - 1;
>  
> +       memleak_alloc(table, size, 1, GFP_ATOMIC);
> +
>         return table;
>  }

Why is this sucker GFP_ATOMIC?

Since alloc_large_system_hash() is using bootmem (and is called early),
I'm a little surprised that it is OK to call into memleak_alloc() which
uses kmem_cache_alloc().  Is the slab even set up at this point?

-- Dave

