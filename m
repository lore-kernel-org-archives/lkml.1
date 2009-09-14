Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbZINKvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbZINKvp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 06:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755068AbZINKv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 06:51:28 -0400
Received: from iksaif.net ([88.191.73.63]:44080 "EHLO iksaif.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbZINKvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 06:51:24 -0400
From: Corentin Chary <corentincj@iksaif.net>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Julia Lawall <julia@diku.dk>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Johannes Berg <johannes@sipsolutions.net>,
       Corentin Chary <corentincj@iksaif.net>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: [PATCH 2/3] thinkpad_acpi: fix rfkill memory leak on unload
Date: Mon, 14 Sep 2009 12:43:52 +0200
Message-Id: <1252925033-29696-3-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252925033-29696-2-git-send-email-corentincj@iksaif.net>
References: <1252925033-29696-1-git-send-email-corentincj@iksaif.net>
 <1252925033-29696-2-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rfkill_unregister() should always be followed by rfkill_destroy()

Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/thinkpad_acpi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index e856008..21c9715 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -1278,6 +1278,7 @@ static void tpacpi_destroy_rfkill(const enum tpacpi_rfk_id id)
 	tp_rfk = tpacpi_rfkill_switches[id];
 	if (tp_rfk) {
 		rfkill_unregister(tp_rfk->rfkill);
+		rfkill_destroy(tp_rfk->rfkill);
 		tpacpi_rfkill_switches[id] = NULL;
 		kfree(tp_rfk);
 	}
-- 
1.6.4.2

