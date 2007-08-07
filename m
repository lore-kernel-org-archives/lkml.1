Return-Path: <linux-kernel-owner+w=401wt.eu-S1757998AbXHGS2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998AbXHGS2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 14:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbXHGS2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 14:28:32 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:42350 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbXHGS2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 14:28:32 -0400
Date: Tue, 7 Aug 2007 20:28:40 +0200
From: Olaf Hering <olaf@aepfle.de>
To: linux-kernel@vger.kernel.org
Subject: CONFIG_SWAP=n failes to compile due to linux/pagemap.h issues
Message-ID: <20070807182840.GA30866@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-Werror-implicit-function-declaration made it finally into mainline,
thats ok.

But now CONFIG_SWAP=n fails to compile, at least on powerpc:

include/asm-generic/tlb.h: In function 'tlb_flush_mmu':
include/asm-generic/tlb.h:76: error: implicit declaration of function 'release_pages'
include/asm-generic/tlb.h: In function 'tlb_remove_page':
include/asm-generic/tlb.h:105: error: implicit declaration of function 'page_cache_release'

tlb_flush_mmu() calls free_pages_and_swap_cache(),
which calls free_pages_and_swap_cache() in linux/swap.h

A commend was added to the free_pages_and_swap_cache define the last
time this issue came up. sparc can not use linux/pagemap.h in swap.h.
http://lkml.org/lkml/2005/7/8/140
http://lkml.org/lkml/2005/8/6/72

So, how can this be finally resolved?
Does CONFIG_SWAP=n compile anywhere right now?

google found a workaround(?), akpm queued it up: http://lkml.org/lkml/2007/7/19/14
