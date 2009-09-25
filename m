Return-Path: <linux-kernel-owner+w=401wt.eu-S1753266AbZIYDHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbZIYDHi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 23:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752978AbZIYDHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 23:07:37 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:51927 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbZIYDHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 23:07:37 -0400
Date: Fri, 25 Sep 2009 12:07:06 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] nommu: Correct is_vmamloc_or_module_addr() definition.
Message-ID: <20090925030706.GE12099@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 81ac3ad9061dd9cd490ee92f0c5316a14d77ce18 broke the nommu build
due to is_vmalloc_or_module_addr() not being marked inline. Fix it up.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---

 include/linux/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index b6eae5e..23e7fd6 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -288,7 +288,7 @@ static inline int is_vmalloc_addr(const void *x)
 #ifdef CONFIG_MMU
 extern int is_vmalloc_or_module_addr(const void *x);
 #else
-static int is_vmalloc_or_module_addr(const void *x)
+static inline int is_vmalloc_or_module_addr(const void *x)
 {
 	return 0;
 }
