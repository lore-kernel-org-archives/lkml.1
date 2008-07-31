Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbYGaCz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbYGaCz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 22:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754954AbYGaCuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 22:50:10 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:60575 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754996AbYGaCuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 22:50:08 -0400
Date: Wed, 30 Jul 2008 21:49:36 -0500
From: David Fries <david@fries.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-kernel@vger.kernel.org
Subject: [PATCH 14/30] W1: w1_therm consistent mutex access code cleanup
Message-ID: <20080731024936.GO12181@spacedout.fries.net>
References: <20080729020433.GA24424@spacedout.fries.net> <20080729161356.2de456fb.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729161356.2de456fb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Wed, 30 Jul 2008 21:49:36 -0500 (CDT)
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
