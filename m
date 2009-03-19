Return-Path: <linux-kernel-owner+w=401wt.eu-S1754931AbZCSL6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931AbZCSL6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 07:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbZCSL6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 07:58:08 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:42279 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbZCSL6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 07:58:07 -0400
Date: Thu, 19 Mar 2009 13:58:01 +0200 (EET)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@wrl-59.cs.helsinki.fi
To: LKML <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] dell-laptop: fix uninitialized/wrong return value
Message-ID: <Pine.LNX.4.64.0903191344170.27609@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-696208474-1496765353-1237463881=:27609"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696208474-1496765353-1237463881=:27609
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

Seriously, a helper would be much nicer here instead of all
that copy paste but I leave that as future work item.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
---
 drivers/platform/x86/dell-laptop.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index 16e11c2..3ee0465 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -249,8 +249,10 @@ static int dell_setup_rfkill(void)
 
 	if ((status & (1<<2|1<<8)) == (1<<2|1<<8)) {
 		wifi_rfkill = rfkill_allocate(NULL, RFKILL_TYPE_WLAN);
-		if (!wifi_rfkill)
+		if (!wifi_rfkill) {
+			ret = -ENOMEM;
 			goto err_wifi;
+		}
 		wifi_rfkill->name = "dell-wifi";
 		wifi_rfkill->toggle_radio = dell_wifi_set;
 		wifi_rfkill->get_state = dell_wifi_get;
@@ -261,8 +263,10 @@ static int dell_setup_rfkill(void)
 
 	if ((status & (1<<3|1<<9)) == (1<<3|1<<9)) {
 		bluetooth_rfkill = rfkill_allocate(NULL, RFKILL_TYPE_BLUETOOTH);
-		if (!bluetooth_rfkill)
+		if (!bluetooth_rfkill) {
+			ret = -ENOMEM;
 			goto err_bluetooth;
+		}
 		bluetooth_rfkill->name = "dell-bluetooth";
 		bluetooth_rfkill->toggle_radio = dell_bluetooth_set;
 		bluetooth_rfkill->get_state = dell_bluetooth_get;
@@ -273,8 +277,10 @@ static int dell_setup_rfkill(void)
 
 	if ((status & (1<<4|1<<10)) == (1<<4|1<<10)) {
 		wwan_rfkill = rfkill_allocate(NULL, RFKILL_TYPE_WWAN);
-		if (!wwan_rfkill)
+		if (!wwan_rfkill) {
+			ret = -ENOMEM;
 			goto err_wwan;
+		}
 		wwan_rfkill->name = "dell-wwan";
 		wwan_rfkill->toggle_radio = dell_wwan_set;
 		wwan_rfkill->get_state = dell_wwan_get;
-- 
1.5.2.2

---696208474-1496765353-1237463881=:27609--
