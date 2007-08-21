Return-Path: <linux-kernel-owner+w=401wt.eu-S1759647AbXHURnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759647AbXHURnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 13:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760218AbXHURnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 13:43:39 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:59677 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761348AbXHURni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 13:43:38 -0400
Date: Tue, 21 Aug 2007 13:38:30 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: [PATCH] SLUB Use cmpxchg() everywhere
Message-ID: <20070821173830.GA14581@Krystal>
References: <20070820201519.512791382@polymtl.ca> <20070820201822.597720007@polymtl.ca> <Pine.LNX.4.64.0708201330130.30053@schroedinger.engr.sgi.com> <20070820204126.GA22507@Krystal> <Pine.LNX.4.64.0708201346160.30353@schroedinger.engr.sgi.com> <20070820212922.GA27011@Krystal> <Pine.LNX.4.64.0708201448080.31411@schroedinger.engr.sgi.com> <20070820215413.GA28452@Krystal> <Pine.LNX.4.64.0708201506010.32213@schroedinger.engr.sgi.com> <20070820222922.GA29814@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070820222922.GA29814@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:36:38 up 22 days, 17:55,  5 users,  load average: 0.67, 0.42, 0.43
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

SLUB Use cmpxchg() everywhere.

It applies to "SLUB: Single atomic instruction alloc/free using
cmpxchg".

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: slab/mm/slub.c
===================================================================
--- slab.orig/mm/slub.c	2007-08-20 18:42:16.000000000 -0400
+++ slab/mm/slub.c	2007-08-20 18:42:28.000000000 -0400
@@ -1682,7 +1682,7 @@ redo:
 
 	object[c->offset] = freelist;
 
-	if (unlikely(cmpxchg_local(&c->freelist, freelist, object) != freelist))
+	if (unlikely(cmpxchg(&c->freelist, freelist, object) != freelist))
 		goto redo;
 	return;
 slow:
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
