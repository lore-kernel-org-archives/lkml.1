Return-Path: <linux-kernel-owner+w=401wt.eu-S1758897AbZGGUhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758897AbZGGUhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 16:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757849AbZGGUhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 16:37:19 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:58870 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756402AbZGGUhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 16:37:16 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: akpm@linux-foundation.org
Cc: leo@marco.de, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] DMI: fix dmi_get_year year parsing
Date: Tue,  7 Jul 2009 22:36:30 +0200
Message-Id: <1246998990-9594-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't guess a year number base. Use 10 instead, since year may
be 2-digit starting with 0, so that we would end up in base equal
to 8.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Reported-by: Matthias Pfaller <leo@marco.de>
---
 drivers/firmware/dmi_scan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index 6071078..8fe0f6e 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -611,7 +611,7 @@ int dmi_get_year(int field)
 		return 0;
 
 	s += 1;
-	year = simple_strtoul(s, NULL, 0);
+	year = simple_strtoul(s, NULL, 10);
 	if (year && year < 100) {	/* 2-digit year */
 		year += 1900;
 		if (year < 1996)	/* no dates < spec 1.0 */
-- 
1.6.3.2

