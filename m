Return-Path: <linux-kernel-owner+w=401wt.eu-S1753597Ab0AYK7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab0AYK7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 05:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325Ab0AYK7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 05:59:19 -0500
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:60364 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753190Ab0AYK7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 05:59:18 -0500
Subject: [PATCH]  cpuidle menu: remove 8 bytes of padding on 64 bit builds
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Arjan van de Ven <arjan@linux.intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jan 2010 10:59:16 +0000
Message-ID: <1264417156.2039.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reorder struct menu_device to remove 8 bytes of padding on 64 bit
builds. Size drops from 136 to 128 bytes, so possibly needing one fewer
cache lines.


Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

-----
patch against 2.6.33-rc5
compile tested only

regards
Richard


diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 73655ae..1aea715 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -100,8 +100,8 @@ struct menu_device {
 	int             needs_update;
 
 	unsigned int	expected_us;
-	u64		predicted_us;
 	unsigned int	measured_us;
+	u64		predicted_us;
 	unsigned int	exit_us;
 	unsigned int	bucket;
 	u64		correction_factor[BUCKETS];


