Return-Path: <linux-kernel-owner+w=401wt.eu-S1756849AbZCOSZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbZCOSZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 14:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756328AbZCOSYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 14:24:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:42366 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057AbZCOSYx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 14:24:53 -0400
Date: Sun, 15 Mar 2009 11:24:38 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH] async: remove the temporary (2.6.29) "async is off by
 default" code
Message-ID: <20090315112438.79f40526@infradead.org>
In-Reply-To: <20090315112345.764fc4ac@infradead.org>
References: <20090315112345.764fc4ac@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From bfcfecd5ccfaa76011d8eba8f6c8ed486d57e0ab Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sun, 15 Mar 2009 11:11:44 -0700
Subject: [PATCH] async: remove the temporary (2.6.29) "async is off by default" code

Now that everyone has been able to test the async code (and it's being used
in the Moblin betas by default), we can enable it by default.
The various fixes needed have gone into 2.6.29 already.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 kernel/async.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/kernel/async.c b/kernel/async.c
index f565891..247ab12 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -391,16 +391,8 @@ static int __init async_init(void)
 		if (IS_ERR(kthread_run(async_manager_thread, NULL,
 				       "async/mgr")))
 			async_enabled = 0;
-	return 0;
-}
-
-static int __init setup_async(char *str)
-{
 	async_enabled = 1;
-	return 1;
+	return 0;
 }
 
-__setup("fastboot", setup_async);
-
-
 core_initcall(async_init);
-- 
1.6.0.6




-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
