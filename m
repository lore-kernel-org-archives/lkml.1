Return-Path: <linux-kernel-owner+w=401wt.eu-S1752343AbZKVJx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbZKVJx4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 04:53:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751720AbZKVJxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 04:53:55 -0500
Received: from casper.infradead.org ([85.118.1.10]:34094 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbZKVJxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 04:53:54 -0500
Subject: Re: [PATCH] mtd: fix mtd_blkdevs problem with caches on some
 architectures (2.6.31)
From: David Woodhouse <dwmw2@infradead.org>
To: Ilya Loginov <isloginov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Peter Horton <phorton@bitbox.co.uk>,
       "Ed L. Cashin" <ecashin@coraid.com>, Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <20091122124631.908a32c4.isloginov@gmail.com>
References: <20091118170810.2bb9cd54.isloginov@gmail.com>
	 <20091120163751.731781e8.akpm@linux-foundation.org>
	 <20091121170437.0839daef.isloginov@gmail.com>
	 <20091121095429.1378828c.akpm@linux-foundation.org>
	 <20091122021128.db47e202.isloginov@gmail.com>
	 <20091121152633.8c79e341.akpm@linux-foundation.org>
	 <20091122124631.908a32c4.isloginov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 22 Nov 2009 09:53:50 +0000
Message-ID: <1258883630.1127.45.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 (2.28.1-2.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-11-22 at 12:46 +0300, Ilya Loginov wrote:
> 
> +#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
>  #define flush_dcache_page(page)                        do { } while (0)
>  #define flush_dcache_mmap_lock(mapping)                do { } while (0)
>  #define flush_dcache_mmap_unlock(mapping)      do { } while (0) 

The thing is, having a function called flush_dcache_page() which doesn't
actually flush a page of the dcache is just blatantly stupid.

It's misnamed -- it should probably be called something like
'flush_valiased_dcache_page()' or 'unalias_dcache_page()' instead, since
I believe it's only supposed to cope with aliasing issues with virtually
indexed caches.

If you're talking about _extending_ the existing silly name to a new
ARCH_IMPLEMENTS_FOO macro or Kconfig option, perhaps this would be a
good time to fix the nomenclature, rather than propagating the error?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

