Return-Path: <linux-kernel-owner+w=401wt.eu-S1758692AbYFOOiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758692AbYFOOiA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 10:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757692AbYFOOhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 10:37:53 -0400
Received: from host102-127-dynamic.20-87-r.retail.telecomitalia.it ([87.20.127.102]:29036
	"EHLO linux.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757667AbYFOOhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 10:37:52 -0400
X-Greylist: delayed 559 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Jun 2008 10:37:52 EDT
From: Andrea Righi <righi.andrea@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <david-b@pacbell.net>
Cc: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@suse.cz>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Andrea Righi <righi.andrea@gmail.com>
Subject: [PATCH -mm] PM: fix 2.6.26-rc5-mm3 build error with CONFIG_PM_TEST_SUSPEND=y
Date: Sun, 15 Jun 2008 16:28:32 +0200
Message-Id: <1213540112-2918-1-git-send-email-righi.andrea@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/power/main.c: In function ‘test_suspend’:
kernel/power/main.c:688: warning: passing argument 2 of ‘class_find_device’ from incompatible pointer type
kernel/power/main.c:688: error: too few arguments to function ‘class_find_device’
make[2]: *** [kernel/power/main.o] Error 1
make[1]: *** [kernel/power] Error 2
make: *** [kernel] Error 2

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 kernel/power/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/power/main.c b/kernel/power/main.c
index e937cc8..2bf3d5b 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -685,7 +685,7 @@ static int __init test_suspend(void)
 	}
 
 	/* RTCs have initialized by now too ... can we use one? */
-	class_find_device(rtc_class, &pony, has_wakealarm);
+	class_find_device(rtc_class, NULL, &pony, has_wakealarm);
 	if (pony)
 		rtc = rtc_class_open(pony);
 	if (!rtc) {
-- 
1.5.4.3

