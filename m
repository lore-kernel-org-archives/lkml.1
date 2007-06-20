Return-Path: <linux-kernel-owner+w=401wt.eu-S1758784AbXFTLk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758784AbXFTLk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 07:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbXFTLks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 07:40:48 -0400
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:52326 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbXFTLkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 07:40:46 -0400
Message-ID: <4679122C.8030202@linux.vnet.ibm.com>
Date: Wed, 20 Jun 2007 17:10:28 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.osdl.org>, linux-mm@kvack.org
CC: Balbir Singh <balbir@in.ibm.com>, Pavel Emelianov <xemul@sw.ru>,
       Paul Menage <menage@google.com>, Kirill Korotaev <dev@sw.ru>,
       devel@openvz.org, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Herbert Poetzl <herbert@13thfloor.at>, Roy Huang <royhuang9@gmail.com>,
       Aubrey Li <aubreylee@gmail.com>
Subject: [RFC][PATCH 4/4] Pagecache reclaim
References: <46791098.4010801@linux.vnet.ibm.com>
In-Reply-To: <46791098.4010801@linux.vnet.ibm.com>
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
@@ -274,9 +274,6 @@ void container_rss_move_lists(struct pag
 	struct rss_container *rss;
 	struct page_container *pc;

-	if (!page_mapped(pg))
-		return;
-
 	pc = page_container(pg);
 	if (pc == NULL)
 		return;
