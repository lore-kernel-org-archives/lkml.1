Return-Path: <linux-kernel-owner+w=401wt.eu-S1754498AbYLEDV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbYLEDV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 22:21:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750720AbYLEDVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 22:21:18 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43636 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbYLEDVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 22:21:18 -0500
Date: Fri, 5 Dec 2008 12:20:24 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [memcg BUG ?] failed to boot on IA64 with CONFIG_DISCONTIGMEM=y
Message-Id: <20081205122024.3fcc1d0e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <49389B69.9010902@cn.fujitsu.com>
References: <49389B69.9010902@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Dec 2008 11:09:29 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> Kernel version: 2.6.28-rc7
> Arch: IA64
> Memory model: DISCONTIGMEM
> 
> ELILO boot: Uncompressing Linux... done
> Loading file initrd-2.6.28-rc7-lizf.img...done
> (frozen)
> 
> 
> Booted successfully with cgroup_disable=memory, here is the dmesg:
> 

thx, will dig into...Maybe you're the first person using DISCONTIGMEM with
empty_node after page_cgroup-alloc-at-boot.

How about this ?
-Kame
==

From: kamezawa.hiroyu@jp.fujitsu.com

page_cgroup should ignore empty-nodes.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 mm/page_cgroup.c |    3 +++
 1 file changed, 3 insertions(+)

Index: mmotm-2.6.28-Dec03/mm/page_cgroup.c
===================================================================
--- mmotm-2.6.28-Dec03.orig/mm/page_cgroup.c
+++ mmotm-2.6.28-Dec03/mm/page_cgroup.c
@@ -51,6 +51,9 @@ static int __init alloc_node_page_cgroup
 	start_pfn = NODE_DATA(nid)->node_start_pfn;
 	nr_pages = NODE_DATA(nid)->node_spanned_pages;
 
+	if (!nr_pages)
+		return;
+
 	table_size = sizeof(struct page_cgroup) * nr_pages;
 
 	base = __alloc_bootmem_node_nopanic(NODE_DATA(nid),

