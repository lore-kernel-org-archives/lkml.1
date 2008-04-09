Return-Path: <linux-kernel-owner+w=401wt.eu-S1754162AbYDIKI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbYDIKI5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 06:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbYDIKIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 06:08:47 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:52440 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbYDIKIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 06:08:46 -0400
Message-ID: <47FC95AD.1070907@tiscali.nl>
Date: Wed, 09 Apr 2008 12:08:45 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: linux-mm@kvack.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] pagewalk: don't pte_unmap(NULL) in walk_pte_range()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is right isn't it?
---
Don't pte_unmap a NULL pointer, but the previous.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 1cf1417..6615f0b 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -15,7 +15,7 @@ static int walk_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 		       break;
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 
-	pte_unmap(pte);
+	pte_unmap(pte - 1);
 	return err;
 }
 
