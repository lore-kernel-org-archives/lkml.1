Return-Path: <linux-kernel-owner+w=401wt.eu-S1161327AbXDXORs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161327AbXDXORs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 10:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161464AbXDXORr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 10:17:47 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:33306 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161327AbXDXORr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 10:17:47 -0400
X-Greylist: delayed 404 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Apr 2007 10:17:47 EDT
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Subject: [PATCH] MM: use DIV_ROUND_UP() in mm/memory.c
Date: Tue, 24 Apr 2007 16:10:22 +0200
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200704241610.23342.eike-kernel@sf-tec.de>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This should make no difference in behaviour.

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>

---
commit 64aa7c3136258d3abc76354b5f83b9a9575169c0
tree 8037adc04b57cd6150456399b7caccf99489385a
parent bf0bd376f79cadb4f8cd454db1723eb9be0aabc1
author Rolf Eike Beer <eike-kernel@sf-tec.de> Tue, 24 Apr 2007 16:05:40 +0200
committer Rolf Eike Beer <eike-kernel@sf-tec.de> Tue, 24 Apr 2007 16:05:40 
+0200

 mm/memory.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index e7066e7..45bba1f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1838,12 +1838,11 @@ void unmap_mapping_range(struct address_space 
*mapping,
 {
 	struct zap_details details;
 	pgoff_t hba = holebegin >> PAGE_SHIFT;
-	pgoff_t hlen = (holelen + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	pgoff_t hlen = DIV_ROUND_UP(holelen, PAGE_SIZE);
 
 	/* Check for overflow. */
 	if (sizeof(holelen) > sizeof(hlen)) {
-		long long holeend =
-			(holebegin + holelen + PAGE_SIZE - 1) >> PAGE_SHIFT;
+		long long holeend = DIV_ROUND_UP(holebegin + holelen, PAGE_SIZE);
 		if (holeend & ~(long long)ULONG_MAX)
 			hlen = ULONG_MAX - hba + 1;
 	}
@@ -2592,7 +2591,7 @@ int make_pages_present(unsigned long addr, unsigned long 
end)
 	write = (vma->vm_flags & VM_WRITE) != 0;
 	BUG_ON(addr >= end);
 	BUG_ON(end > vma->vm_end);
-	len = (end+PAGE_SIZE-1)/PAGE_SIZE-addr/PAGE_SIZE;
+	len = DIV_ROUND_UP(end, PAGE_SIZE) - addr/PAGE_SIZE;
 	ret = get_user_pages(current, current->mm, addr,
 			len, write, 0, NULL, NULL);
 	if (ret < 0)
