Return-Path: <linux-kernel-owner+w=401wt.eu-S1760860AbYGKNvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760860AbYGKNvu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 09:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759451AbYGKNsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 09:48:04 -0400
Received: from zbr.yandex.ru ([213.180.219.33]:34975 "EHLO gavana.yandex.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758688AbYGKNrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 09:47:55 -0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, David Fries <david@fries.net>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 14/30] W1: w1_therm consistent mutex access code cleanup
Date: Fri, 11 Jul 2008 17:51:29 +0400
Message-Id: <12157843062419-git-send-email-johnpol@2ka.mipt.ru>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
References: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sl->master->mutex and dev->mutex refer to the same mutex variable, but
be consistent and use the same set of pointers for the lock and unlock
calls.  It is less confusing (and one less pointer dereference this
way).

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

---
 drivers/w1/slaves/w1_therm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/w1/slaves/w1_therm.c b/drivers/w1/slaves/w1_therm.c
index 7de99df..2c8dff9 100644
--- a/drivers/w1/slaves/w1_therm.c
+++ b/drivers/w1/slaves/w1_therm.c
@@ -171,7 +171,7 @@ static ssize_t w1_therm_read(struct device *device,
 	int i, max_trying = 10;
 	ssize_t c = PAGE_SIZE;
 
-	mutex_lock(&sl->master->mutex);
+	mutex_lock(&dev->mutex);
 
 	memset(rom, 0, sizeof(rom));
 
-- 
1.4.4.4

