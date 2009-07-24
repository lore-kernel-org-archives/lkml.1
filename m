Return-Path: <linux-kernel-owner+w=401wt.eu-S1752864AbZGXNTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbZGXNTr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 09:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752746AbZGXNTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 09:19:46 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:40620 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbZGXNTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 09:19:45 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>,
       Matt Reimer <mreimer@vpop.net>, Anton Vorontsov <cbou@mail.ru>
Subject: [PATCH] ds2760: fix integer overflow for time_to_empty_now
Date: Fri, 24 Jul 2009 15:19:33 +0200
Message-Id: <1248441573-32712-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the device we're currently developing, battery sizes of ~2.8Ah and
current flow of ~600mA are typical.

With that values, the life_sec computation overflows due to the
multiplication by 3600.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>
Cc: Matt Reimer <mreimer@vpop.net>
Cc: Anton Vorontsov <cbou@mail.ru>

Signed-off-by: Daniel Mack <daniel@caiaq.de>
---
 drivers/power/ds2760_battery.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/ds2760_battery.c b/drivers/power/ds2760_battery.c
index d545fee..5d30dc0 100644
--- a/drivers/power/ds2760_battery.c
+++ b/drivers/power/ds2760_battery.c
@@ -212,8 +212,8 @@ static int ds2760_battery_read_status(struct ds2760_device_info *di)
 		di->rem_capacity = 100;
 
 	if (di->current_uA)
-		di->life_sec = -((di->accum_current_uAh - di->empty_uAh) *
-				 3600L) / di->current_uA;
+		di->life_sec = -((di->accum_current_uAh - di->empty_uAh) * 36L)
+					/ (di->current_uA / 100L);
 	else
 		di->life_sec = 0;
 
-- 
1.6.3.1

