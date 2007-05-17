Return-Path: <linux-kernel-owner+w=401wt.eu-S1756027AbXERIE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbXERIE1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 04:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755687AbXERIDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 04:03:44 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:45562 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755487AbXERIDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 04:03:41 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] MM: use DIV_ROUND_UP() in mm/memory.c
Date: Thu, 17 May 2007 23:05:10 +0200
User-Agent: KMail/1.9.6
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <200704241610.23342.eike-kernel@sf-tec.de> <20070503202808.4f835c8a.akpm@linux-foundation.org>
In-Reply-To: <20070503202808.4f835c8a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705172305.11267.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replace a hand coded version of DIV_ROUND_UP().

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de

---
commit ab35916f807eb4f2019a208e96cb0bddbb91dfc3
tree 6dc4485902c1a96a09ed287270de108630b26719
parent 335aa0289219ca2c1dc309d6bf856d4b25ad8746
author Rolf Eike Beer <eike-kernel@sf-tec.de> Thu, 17 May 2007 23:03:06 +0200
committer Rolf Eike Beer <eike-kernel@sf-tec.de> Thu, 17 May 2007 23:03:06 +0200

 mm/memory.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index cb94488..5bc26b7 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2674,7 +2674,7 @@ int make_pages_present(unsigned long addr, unsigned long end)
 	write = (vma->vm_flags & VM_WRITE) != 0;
 	BUG_ON(addr >= end);
 	BUG_ON(end > vma->vm_end);
-	len = (end+PAGE_SIZE-1)/PAGE_SIZE-addr/PAGE_SIZE;
+	len = DIV_ROUND_UP(end, PAGE_SIZE) - addr/PAGE_SIZE;
 	ret = get_user_pages(current, current->mm, addr,
 			len, write, 0, NULL, NULL);
 	if (ret < 0)
