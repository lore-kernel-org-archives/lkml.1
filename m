Return-Path: <linux-kernel-owner+w=401wt.eu-S1758549AbXEJJGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758549AbXEJJGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 05:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755561AbXEJJGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 05:06:12 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33169 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287AbXEJJGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 05:06:11 -0400
Date: Thu, 10 May 2007 18:05:56 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, Lee.Schermerhorn@hp.com,
       apw@shadowen.org, clameter@sgi.com, ak@suse.de,
       jbarnes@virtuousgeek.org
Subject: Re: [Request-For-Test] [PATCH] change zonelist order v6 [0/3]
 Introduction
Message-Id: <20070510180556.febd7a5d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070510013619.7b8c2457.akpm@linux-foundation.org>
References: <20070510161611.fe1a696b.kamezawa.hiroyu@jp.fujitsu.com>
	<20070510013619.7b8c2457.akpm@linux-foundation.org>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 01:36:19 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 10 May 2007 16:16:11 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > This is zonelist-order-fix patch version 6. against 2.6.21-mm2.
> 
> This is new:
> 
> WARNING: mm/built-in.o - Section mismatch: reference to .init.text: from .text between '__build_all_zonelists' (at offset 0x3d13) and 'build_all_zonelists'
> WARNING: mm/built-in.o - Section mismatch: reference to .init.text: from .text between '__build_all_zonelists' (at offset 0x3d2c) and 'build_all_zonelists'
> WARNING: mm/built-in.o - Section mismatch: reference to .init.text: from .text between '__build_all_zonelists' (at offset 0x3d4b) and 'build_all_zonelists'
> 
> Using http://userweb.kernel.org/~akpm/config-sony.txt
> 
> Maybe it wasn't your match which did this, I didn't check.
> 
Ah....thank you. this is fix. I turned off memory-hotplug and this is patch.
Because precise control of this meminit will need some #ifdef,
I removed them all.

-Kame
==
Fixes section mismatch.

Signed-Off-By: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Index: linux-2.6.21-mm2/mm/page_alloc.c
===================================================================
--- linux-2.6.21-mm2.orig/mm/page_alloc.c
+++ linux-2.6.21-mm2/mm/page_alloc.c
@@ -1974,7 +1974,7 @@ void show_free_areas(void)
  *
  * Add all populated zones of a node to the zonelist.
  */
-static int __meminit build_zonelists_node(pg_data_t *pgdat,
+static int build_zonelists_node(pg_data_t *pgdat,
 			struct zonelist *zonelist, int nr_zones, enum zone_type zone_type)
 {
 	struct zone *zone;
@@ -2324,7 +2324,7 @@ static void build_zonelists(pg_data_t *p
 }
 
 /* Construct the zonelist performance cache - see further mmzone.h */
-static void __meminit build_zonelist_cache(pg_data_t *pgdat)
+static void build_zonelist_cache(pg_data_t *pgdat)
 {
 	int i;
 
@@ -2349,7 +2349,7 @@ static void set_zonelist_order(void)
 	current_zonelist_order = ZONELIST_ORDER_ZONE;
 }
 
-static void __meminit build_zonelists(pg_data_t *pgdat)
+static void build_zonelists(pg_data_t *pgdat)
 {
 	int node, local_node;
 	enum zone_type i,j;
@@ -2385,7 +2385,7 @@ static void __meminit build_zonelists(pg
 }
 
 /* non-NUMA variant of zonelist performance cache - just NULL zlcache_ptr */
-static void __meminit build_zonelist_cache(pg_data_t *pgdat)
+static void build_zonelist_cache(pg_data_t *pgdat)
 {
 	int i;
 

