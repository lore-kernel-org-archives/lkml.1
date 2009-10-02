Return-Path: <linux-kernel-owner+w=401wt.eu-S1756247AbZJBIh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247AbZJBIh7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 04:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbZJBIh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 04:37:58 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41285 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbZJBIh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 04:37:57 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/3] Mark strstrip() as must_check
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20091002173635.5F6C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  2 Oct 2009 17:37:58 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In few weeks ago discussion, Andrew Morton pointed out strstrip()
should be must_check, because it was often abused.

This patch does that.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/linux/string.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/string.h b/include/linux/string.h
index 489019e..b850886 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -62,7 +62,7 @@ extern char * strnchr(const char *, size_t, int);
 #ifndef __HAVE_ARCH_STRRCHR
 extern char * strrchr(const char *,int);
 #endif
-extern char * strstrip(char *);
+extern char * __must_check strstrip(char *);
 #ifndef __HAVE_ARCH_STRSTR
 extern char * strstr(const char *,const char *);
 #endif
-- 
1.6.0.GIT



