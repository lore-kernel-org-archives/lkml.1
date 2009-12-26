Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbZLZT3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbZLZT3Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 14:29:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753347AbZLZT3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 14:29:15 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:34976 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbZLZT3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 14:29:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=DVks+BzfAwNuVP+bX8XYgnCuim2IINo6IPTmldGMTZtc/9Gte7GQeos++CjKXXkIED
         6xgV39HdbicwXE8dajyWwQoMNS31v24NOgqPEzACdLFEJVK5XQQUX1kAYo6W7Od2RxtQ
         Gb3iISKMM1zOuGOLmV8J1jSQnDNTTj5BVtqtc=
Message-ID: <4B3664AF.6090302@gmail.com>
Date: Sat, 26 Dec 2009 20:31:59 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] wl1251: timeout one too soon in wl1251_boot_run_firmware()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`loop' reaches INIT_LOOP + 1 after the loop. so if ACX_INTR_INIT_COMPLETE
occurs in the last iteration the write occurs but also the error out as if a
timeout occurred. This is probably very unlikely to ever occur.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/net/wireless/wl12xx/wl1251_boot.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_boot.c b/drivers/net/wireless/wl12xx/wl1251_boot.c
index 2e733e7..28a8086 100644
--- a/drivers/net/wireless/wl12xx/wl1251_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1251_boot.c
@@ -256,7 +256,7 @@ int wl1251_boot_run_firmware(struct wl1251 *wl)
 		}
 	}
 
-	if (loop >= INIT_LOOP) {
+	if (loop > INIT_LOOP) {
 		wl1251_error("timeout waiting for the hardware to "
 			     "complete initialization");
 		return -EIO;
