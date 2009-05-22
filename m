Return-Path: <linux-kernel-owner+w=401wt.eu-S1756377AbZEVIDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377AbZEVIDQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 04:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbZEVICx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 04:02:53 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:48506 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbZEVICw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 04:02:52 -0400
Subject: Re: [PATCH] slab: fix generic PAGE_POISONING conflict with
 SLAB_RED_ZONE
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ron <ron@debian.org>
Cc: cl@linux-foundation.org, mpm@selenic.com, linux-mm@kvack.org,
       akinobu.mita@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <20090521192822.GB4448@homer.shelbyville.oz>
References: <20090521192822.GB4448@homer.shelbyville.oz>
Date: Fri, 22 May 2009 11:02:52 +0300
Message-Id: <1242979372.13681.1.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-22 at 04:58 +0930, Ron wrote:
> A generic page poisoning mechanism was added with commit:
>  6a11f75b6a17b5d9ac5025f8d048382fd1f47377
> which destructively poisons full pages with a bitpattern.
> 
> On arches where PAGE_POISONING is used, this conflicts with the slab
> redzone checking enabled by DEBUG_SLAB, scribbling bits all over its
> magic words and making it complain about that quite emphatically.
> 
> On x86 (and I presume at present all the other arches which set
> ARCH_SUPPORTS_DEBUG_PAGEALLOC too), the kernel_map_pages() operation
> is non destructive so it can coexist with the other DEBUG_SLAB
> mechanisms just fine.
> 
> This patch favours the expensive full page destruction test for
> cases where there is a collision and it is explicitly selected.
> 
> Signed-off-by: Ron Lee <ron@debian.org>

Applied, thanks!

			Pekka

