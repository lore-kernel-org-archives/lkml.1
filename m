Return-Path: <linux-kernel-owner+w=401wt.eu-S1755005AbYKYE0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005AbYKYE0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 23:26:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbYKYE0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 23:26:00 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46804 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbYKYEZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 23:25:59 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] mm: make maddr __iomem 
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20081125131942.26CD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081125131942.26CD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20081125132501.26D3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 25 Nov 2008 13:25:55 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sparse output following warnings.

mm/memory.c:2936:8: warning: incorrect type in assignment (different address spaces)
mm/memory.c:2936:8:    expected void *maddr
mm/memory.c:2936:8:    got void [noderef] <asn:2>


cleanup here.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/mm/memory.c
===================================================================
--- a/mm/memory.c	2008-11-05 01:11:44.000000000 +0900
+++ b/mm/memory.c	2008-11-22 21:56:31.000000000 +0900
@@ -2922,7 +2922,7 @@ int generic_access_phys(struct vm_area_s
 {
 	resource_size_t phys_addr;
 	unsigned long prot = 0;
-	void *maddr;
+	void __iomem *maddr;
 	int offset = addr & (PAGE_SIZE-1);
 
 	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))


