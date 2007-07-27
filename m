Return-Path: <linux-kernel-owner+w=401wt.eu-S965043AbXG0Jvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965043AbXG0Jvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 05:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936605AbXG0JrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 05:47:07 -0400
Received: from sicnat3.emn.fr ([193.54.76.194]:36275 "EHLO ron.emn.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936307AbXG0JrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 05:47:05 -0400
Date: Fri, 27 Jul 2007 11:45:38 +0200 (MEST)
Message-Id: <200707270945.LAA17342@ifs.emn.fr>
To: kernel-janitors@vger.kernel.org
Subject: [PATCH 15/68] 0 -> NULL, for arch/sh64
Cc: lethal@linux-sh.org, linuxsh-shmedia-dev@lists.sourceforge.net,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
From: Yoann Padioleau <padator@wanadoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When comparing a pointer, it's clearer to compare it to NULL than to 0.

Here is an excerpt of the semantic patch: 

@@
expression *E;
@@

  E ==
- 0
+ NULL

@@
expression *E;
@@

  E !=
- 0
+ NULL

Signed-off-by: Yoann Padioleau <padator@wanadoo.fr>
Cc: lethal@linux-sh.org
Cc: linuxsh-shmedia-dev@lists.sourceforge.net
Cc: akpm@linux-foundation.org
---

 ioremap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sh64/mm/ioremap.c b/arch/sh64/mm/ioremap.c
index 9908577..b335849 100644
--- a/arch/sh64/mm/ioremap.c
+++ b/arch/sh64/mm/ioremap.c
@@ -167,7 +167,7 @@ static unsigned long shmedia_alloc_io(un
 
         if (name == NULL) name = "???";
 
-        if ((xres = xres_alloc()) != 0) {
+        if ((xres = xres_alloc()) != NULL) {
                 tack = xres->xname;
                 res = &xres->xres;
         } else {
@@ -364,7 +364,7 @@ ioremap_proc_info(char *buf, char **star
 	for (r = ((struct resource *)data)->child; r != NULL; r = r->sibling) {
 		if (p + 32 >= e)        /* Better than nothing */
 			break;
-		if ((nm = r->name) == 0) nm = "???";
+		if ((nm = r->name) == NULL) nm = "???";
 		p += sprintf(p, "%08lx-%08lx: %s\n",
 			     (unsigned long)r->start,
 			     (unsigned long)r->end, nm);

