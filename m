Return-Path: <linux-kernel-owner+w=401wt.eu-S934459AbYAaR2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934459AbYAaR2Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 12:28:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765866AbYAaR2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 12:28:07 -0500
Received: from ag-out-0708.google.com ([72.14.246.245]:11510 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763486AbYAaR2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 12:28:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Xk4R4fTWu6B9aRKQgq8xWnvI64muP05fsKjr7281K9fAOF9mtHuL3UJS2LvolfZ+/xBlEJeDfDup4eZMQQImUp2PWXuuy0NNYA8YK8v9A+6IlwzGQmJ6K4ag2iOxe1NNkmpn/Mo6l7y7OMYsvoFXtTRxxJT9C58nlX6xXaGLv7o=
Date: Fri, 1 Feb 2008 01:25:17 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Alessandro Guido <alessandro.guido@gmail.com>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       linux-kbuild@vger.kernel.org
Subject: [Patch] mm: fix a section mismatch warning
Message-ID: <20080131172517.GG2471@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <200801311648.43389.alessandro.guido@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801311648.43389.alessandro.guido@gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fix this mismatch warning from mm:

WARNING: vmlinux.o(.meminit.text+0x37f): Section mismatch in reference from the function free_area_init_core() to the function .init.text:setup_usemap()
modpost: Found 1 section mismatch(es).

Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b2838c2..8a9ae3c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3321,7 +3321,7 @@ static inline int pageblock_default_order(unsigned int order)
  *   - mark all memory queues empty
  *   - clear the memory bitmaps
  */
-static void __meminit free_area_init_core(struct pglist_data *pgdat,
+static void __init free_area_init_core(struct pglist_data *pgdat,
 		unsigned long *zones_size, unsigned long *zholes_size)
 {
 	enum zone_type j;
@@ -3445,7 +3445,7 @@ static void __init_refok alloc_node_mem_map(struct pglist_data *pgdat)
 #endif /* CONFIG_FLAT_NODE_MEM_MAP */
 }
 
-void __meminit free_area_init_node(int nid, struct pglist_data *pgdat,
+void __init free_area_init_node(int nid, struct pglist_data *pgdat,
 		unsigned long *zones_size, unsigned long node_start_pfn,
 		unsigned long *zholes_size)
 {
