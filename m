Return-Path: <linux-kernel-owner+w=401wt.eu-S1753476AbYKRO7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbYKRO7Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 09:59:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbYKRO7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 09:59:16 -0500
Received: from casper.infradead.org ([85.118.1.10]:46436 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbYKRO7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 09:59:16 -0500
Date: Tue, 18 Nov 2008 06:59:57 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: rjw@sisk.pl, torvalds@linux-foundation.org
Subject: [PATCH] help kerneloops.org dianogse suspend_test_finish better
Message-ID: <20081118065957.7769c8ba@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please apply this patch to the 2.6.28-rc series; it will help kerneloops.org
to better diagnose the warning in suspend_test_finish(), which is currently
very hot but is lacking the essential detail of which component is causing 
the badness...



From: Arjan van de Ven <arjan@linux.intel.com>
Date: Tue, 18 Nov 2008 06:56:51 -0800
Subject: [PATCH] suspend: use WARN not WARN_ON to print the message

By using WARN(), kerneloops.org can collect which component is causing
the delay and make statistics about that. suspend_test_finish() is
currently the number 2 item but unless we can collect who's causing
it we're not going to be able to fix the hot topic ones..

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 kernel/power/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/power/main.c b/kernel/power/main.c
index 19122cf..b8f7ce9 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -174,7 +174,7 @@ static void suspend_test_finish(const char *label)
 	 * has some performance issues.  The stack dump of a WARN_ON
 	 * is more likely to get the right attention than a printk...
 	 */
-	WARN_ON(msec > (TEST_SUSPEND_SECONDS * 1000));
+	WARN(msec > (TEST_SUSPEND_SECONDS * 1000), "Component: %s\n", label);
 }
 
 #else
-- 
1.6.0.3



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
