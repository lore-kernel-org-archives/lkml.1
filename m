Return-Path: <linux-kernel-owner+w=401wt.eu-S1755800AbXIJJjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800AbXIJJjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 05:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbXIJJjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 05:39:09 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39899 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbXIJJjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 05:39:08 -0400
Date: Mon, 10 Sep 2007 18:40:48 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "kamezawa.hiroyu@jp.fujitsu.com" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH] add page->mapping handling interface [0/35] intro
Message-Id: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, this patch set adds following functions

 - page_inode(page) ... returns inode from page, (page->mapping->host)
 - page_mapping_cache(page) ... returns addrees_space from page
 - page_mapping_anon(page) ... return anon_vma from page
 - page_is_pagecache(page) ... returns 1 if the page is page cache
 - pagecache_consistent(page, mapping) ... returns if page_mapping_cache(page)
   equals to mapping.

By adding aboves, this patch set removes all *direct* references to
page->mapping in usual codes. (compile tested with all mod config.)

I think this can improve VM/FS dependency and make things robust.
In addition,  page->mapping is not a just address_space, now.
(And we can hide page->mapping details from moduled FSs.)

patch set is structured as
[1] ... new interface definition
[2] ... changes in /mm
[3] ... changes in /kernel and /fs
[4...] ... changes in each FSs. (most of patches are very small.)

Any comments are welcome.

Thanks,
-Kame

