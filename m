Return-Path: <linux-kernel-owner+w=401wt.eu-S932121AbZHUHqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121AbZHUHqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 03:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754878AbZHUHqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 03:46:46 -0400
Received: from server1.wserver.cz ([82.113.45.157]:59166 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbZHUHqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 03:46:46 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: akpm@linux-foundation.org
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin\"" <hpa@zytor.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH 1/1] define node_*_pfn for non-NUMA builds
Date: Fri, 21 Aug 2009 09:46:46 +0200
Message-Id: <1250840806-14232-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FWIW "Latest fs/proc/kcore updates" in the changelog are these
from mmotm:
> kcore-use-registerd-physmem-information.patch
> kcore-use-registerd-physmem-information-fix.patch
> kcore-use-registerd-physmem-information-checkpatch-fixes.patch

--

Latest fs/proc/kcore updates need node_end_pfn. To avoid a compiler
error:
fs/proc/kcore.c: In function ‘kcore_update_ram’:
fs/proc/kcore.c:200: error: implicit declaration of function ‘node_end_pfn’
define node_start_pfn and node_end_pfn as simple contig_page_data
accessors on !NUMA builds.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/mmzone.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 9c50309..6789900 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -771,6 +771,9 @@ extern char numa_zonelist_order[];
 extern struct pglist_data contig_page_data;
 #define NODE_DATA(nid)		(&contig_page_data)
 #define NODE_MEM_MAP(nid)	mem_map
+#define node_start_pfn(nid)	(contig_page_data.node_start_pfn)
+#define node_end_pfn(nid)	(contig_page_data.node_start_pfn +	\
+				 contig_page_data.node_spanned_pages)
 
 #else /* CONFIG_NEED_MULTIPLE_NODES */
 
-- 
1.6.3.3

