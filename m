Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbYJ2JE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbYJ2JE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 05:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752811AbYJ2JEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 05:04:20 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:24649 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbYJ2JET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 05:04:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=kViQtgvYhuc8BIp2DWKzsiLscgirVGBGRSrgv5WXO4T7UfusOKQvu5qVv9x7UMpUUc
         iUspOJyQI0XsqOpkKLYcME3eDeYO1YbrCZn0VUGFqWPJuVy7QwBwUojN63l1A0Mz4NJU
         GofODpKpI8Fh8jVQZ2OlKL/14n4DP0tA9fKxQ=
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: cbou@mail.ru, Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>
Subject: [PATCH] power_supply: only register tosa_battery driver on tosa
Date: Wed, 29 Oct 2008 12:04:09 +0300
Message-Id: <1225271050-21171-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are already several wm97xx-battery drivers. Do register the tosa one
only on tosa machines.

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
---
 drivers/power/tosa_battery.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/power/tosa_battery.c b/drivers/power/tosa_battery.c
index 2eab35a..4e52c22 100644
--- a/drivers/power/tosa_battery.c
+++ b/drivers/power/tosa_battery.c
@@ -469,6 +469,9 @@ static struct platform_driver tosa_bat_driver = {
 
 static int __init tosa_bat_init(void)
 {
+	if (!machine_is_tosa())
+		return -EINVAL;
+
 	return platform_driver_register(&tosa_bat_driver);
 }
 
-- 
1.5.6.5

