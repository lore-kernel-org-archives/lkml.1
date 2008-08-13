Return-Path: <linux-kernel-owner+w=401wt.eu-S1757212AbYHMRwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212AbYHMRwr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 13:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756710AbYHMRwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 13:52:37 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:57535 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbYHMRwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 13:52:37 -0400
Date: Wed, 13 Aug 2008 10:51:14 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: eduard.munteanu@linux360.ro, sfr <sfr@canb.auug.org.au>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: [PATCH -next] kmemtrace: fix printk format warnings
Message-Id: <20080813105114.a21a44de.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warnings:

linux-next-20080813/include/linux/kmemtrace.h:33: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'size_t'
linux-next-20080813/include/linux/kmemtrace.h:33: warning: format '%lu' expects type 'long unsigned int', but argument 6 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/linux/kmemtrace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20080813.orig/include/linux/kmemtrace.h
+++ linux-next-20080813/include/linux/kmemtrace.h
@@ -31,7 +31,7 @@ static inline void kmemtrace_mark_alloc_
 					     int node)
 {
 	trace_mark(kmemtrace_alloc, "type_id %d call_site %lu ptr %lu "
-		   "bytes_req %lu bytes_alloc %lu gfp_flags %lu node %d",
+		   "bytes_req %zu bytes_alloc %zu gfp_flags %lu node %d",
 		   type_id, call_site, (unsigned long) ptr,
 		   bytes_req, bytes_alloc, (unsigned long) gfp_flags, node);
 }


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
