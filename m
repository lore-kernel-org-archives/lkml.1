Return-Path: <linux-kernel-owner+w=401wt.eu-S1752492AbZL0Oqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbZL0Oqe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 09:46:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbZL0Oqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 09:46:32 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:36378 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbZL0Oqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 09:46:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=RYE4OliJuEYemBdgU9itSE6Siv6EfERhAq1Sb4sizrE1bJsY7YbEbwwkji+f1MZCLI
         h3jYAwSKXVW80OIG0Gt6ZW4r9JkR95PjTJuCpDg+hqC84AQMS/TDQBb7Oy49Taj3NVmW
         XDAL5VGXv2BhgY5QnOVaVgoOIR41nLTvnAFok=
Message-ID: <4B3773F2.3010703@gmail.com>
Date: Sun, 27 Dec 2009 15:49:22 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
       "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
       linux-i2c@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] i2c: test off by one in {piix4,vt596}_transaction()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With `while (timeout++ < MAX_TIMEOUT)' timeout reaches MAX_TIMEOUT + 1 after the loop
This is probably unlikely to produce a problem.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/i2c/busses/i2c-piix4.c  |    2 +-
 drivers/i2c/busses/i2c-viapro.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-piix4.c b/drivers/i2c/busses/i2c-piix4.c
index 1e245e9..d8e0df0 100644
--- a/drivers/i2c/busses/i2c-piix4.c
+++ b/drivers/i2c/busses/i2c-piix4.c
@@ -329,7 +329,7 @@ static int piix4_transaction(void)
 		msleep(1);
 
 	/* If the SMBus is still busy, we give up */
-	if (timeout >= MAX_TIMEOUT) {
+	if (timeout > MAX_TIMEOUT) {
 		dev_err(&piix4_adapter.dev, "SMBus Timeout!\n");
 		result = -ETIMEDOUT;
 	}
diff --git a/drivers/i2c/busses/i2c-viapro.c b/drivers/i2c/busses/i2c-viapro.c
index e4b1543..8a2e0d5 100644
--- a/drivers/i2c/busses/i2c-viapro.c
+++ b/drivers/i2c/busses/i2c-viapro.c
@@ -168,7 +168,7 @@ static int vt596_transaction(u8 size)
 	} while ((temp & 0x01) && (timeout++ < MAX_TIMEOUT));
 
 	/* If the SMBus is still busy, we give up */
-	if (timeout >= MAX_TIMEOUT) {
+	if (timeout > MAX_TIMEOUT) {
 		result = -ETIMEDOUT;
 		dev_err(&vt596_adapter.dev, "SMBus timeout!\n");
 	}
