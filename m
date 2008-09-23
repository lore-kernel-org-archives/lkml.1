Return-Path: <linux-kernel-owner+w=401wt.eu-S1753358AbYIWUBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbYIWUBl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 16:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbYIWUBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 16:01:33 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:44278 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbYIWUBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 16:01:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:sender;
        b=BAtCg3MPMulECLr5/zp+uueBxFQUFNaknbwxyMGwrtOldEHws1c78Us9HSCnPdrbUO
         Jf5bDAnPyk1IzzZ9TFM5PgzWAFDmyAjJVdeEM6wzrDD7dUeZ3EfYkmfuIZWid9a7d8Xm
         2jhx03JrdiQMgn/nlMqYtGfX8rI3JJATzOvMo=
From: Peter Korsgaard <jacmet@sunsite.dk>
To: gregkh@suse.de, dbrownell@users.sourceforge.net,
       linux-kernel@vger.kernel.org
Cc: Peter Korsgaard <jacmet@sunsite.dk>
Subject: [PATCH] drivers/base: make bus_find_device_by_name() more robust
Date: Tue, 23 Sep 2008 22:01:27 +0200
Message-Id: <1222200087-11533-1-git-send-email-jacmet@sunsite.dk>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use sysfs_streq() in bus_find_device_by_name() so trailing newlines
are ignored (E.G. in bind/unbind).

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
---
 drivers/base/bus.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index ef522ae..39b9b58 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -333,9 +333,7 @@ static int match_name(struct device *dev, void *data)
 {
 	const char *name = data;
 
-	if (strcmp(name, dev->bus_id) == 0)
-		return 1;
-	return 0;
+	return sysfs_streq(name, dev->bus_id);
 }
 
 /**
-- 
1.5.6.3

