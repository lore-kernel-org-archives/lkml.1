Return-Path: <linux-kernel-owner+w=401wt.eu-S1751586AbYJTVux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586AbYJTVux (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 17:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbYJTVup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 17:50:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:38667 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbYJTVup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 17:50:45 -0400
Date: Mon, 20 Oct 2008 14:50:56 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, johannes@sipsolutions.net,
       davem@davemloft.net, Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH] fix WARN() for PPC
Message-ID: <20081020145056.24d84992@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Arjan van de Ven <arjan@linux.intel.com>
Date: Mon, 20 Oct 2008 14:41:03 -0700
Subject: [PATCH] fix WARN() for PPC

powerpc doesn't use the generic WARN_ON infrastructure. The newly introduced WARN()
as a result didn't print the message, this patch adds the printk for this specific case.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 include/asm-generic/bug.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 0f6dabd..12c07c1 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -41,7 +41,7 @@ extern void warn_slowpath(const char *file, const int line,
 #define __WARN() warn_on_slowpath(__FILE__, __LINE__)
 #define __WARN_printf(arg...) warn_slowpath(__FILE__, __LINE__, arg)
 #else
-#define __WARN_printf(arg...) __WARN()
+#define __WARN_printf(arg...) do { printk(arg); __WARN(); } while (0)
 #endif
 
 #ifndef WARN_ON
-- 
1.5.5.1



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
