Return-Path: <linux-kernel-owner+w=401wt.eu-S932429AbXF2GZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429AbXF2GZN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 02:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752825AbXF2GZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 02:25:00 -0400
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:36628 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbXF2GY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 02:24:59 -0400
Message-ID: <4684A523.5090600@linux.vnet.ibm.com>
Date: Fri, 29 Jun 2007 11:52:27 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.osdl.org>,
       linux-mm <linux-mm@kvack.org>
CC: Balbir Singh <balbir@in.ibm.com>, Pavel Emelianov <xemul@sw.ru>,
       Paul Menage <menage@google.com>, Kirill Korotaev <dev@sw.ru>,
       devel@openvz.org, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Herbert Poetzl <herbert@13thfloor.at>, Roy Huang <royhuang9@gmail.com>,
       Aubrey Li <aubreylee@gmail.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [RFC][PATCH 3/3] Pagecache reclaim
References: <4684A3F3.40001@linux.vnet.ibm.com>
In-Reply-To: <4684A3F3.40001@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pagecache controller reclaim changes
------------------------------------

Reclaim path needs performance improvement.
For now it is minor changes to include unmapped
pages in our list of page_container.

Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
---
 mm/rss_container.c |    3 ---
 1 file changed, 3 deletions(-)

--- linux-2.6.22-rc2-mm1.orig/mm/rss_container.c
+++ linux-2.6.22-rc2-mm1/mm/rss_container.c
@@ -243,9 +243,6 @@ void container_rss_move_lists(struct pag
 	struct rss_container *rss;
 	struct page_container *pc;

-	if (!page_mapped(pg))
-		return;
-
 	pc = page_container(pg);
 	if (pc == NULL)
 		return;
