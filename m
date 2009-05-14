Return-Path: <linux-kernel-owner+w=401wt.eu-S1761368AbZENQpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761368AbZENQpB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 12:45:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbZENQou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 12:44:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:43306 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbZENQot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 12:44:49 -0400
Message-ID: <4A0C4A2A.6080009@kernel.org>
Date: Thu, 14 May 2009 09:43:22 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, Jack Steiner <steiner@sgi.com>,
       David Rientjes <rientjes@google.com>
Subject: [PATCH 5/5] mm: clear N_HIGH_MEMORY map before se set it again -v2
References: <4A05269D.8000701@kernel.org> <20090512111623.GG25923@csn.ul.ie> <4A0A64FB.4080504@kernel.org> <20090513145950.GB28097@csn.ul.ie> <4A0C4910.7090508@kernel.org>
In-Reply-To: <4A0C4910.7090508@kernel.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


incase some system strange SRAT table. some kind of small range.
or with mem= etc

v2: fix typo

Signed-off-by: Yinghai Lu <Yinghai@kernel.org>
Tested-by: Jack Steiner <steiner@sgi.com>

---
 mm/page_alloc.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c
+++ linux-2.6/mm/page_alloc.c
@@ -4041,6 +4047,11 @@ void __init free_area_init_nodes(unsigne
 						early_node_map[i].start_pfn,
 						early_node_map[i].end_pfn);
 
+	/*
+	 * find_zone_movable_pfns_for_nodes/early_calculate_totalpages init
+	 * that node_mask, clear it at first
+	 */
+	nodes_clear(node_states[N_HIGH_MEMORY]);
 	/* Initialise every node */
 	mminit_verify_pageflags_layout();
 	setup_nr_node_ids();
