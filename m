Return-Path: <linux-kernel-owner+w=401wt.eu-S1756703AbZDGUps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703AbZDGUps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 16:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754812AbZDGUpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 16:45:40 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:55709 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503AbZDGUpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 16:45:39 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jean Delvare <khali@linux-fr.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       David Brownell <dbrownell@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/2] at24: make input buffers of at24_*write() const
Date: Tue,  7 Apr 2009 22:44:32 +0200
Message-Id: <1239137073-21353-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

| drivers/misc/eeprom/at24.c:508: warning: assignment from incompatible pointer
type

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/misc/eeprom/at24.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/eeprom/at24.c b/drivers/misc/eeprom/at24.c
index d184dfa..db39f4a 100644
--- a/drivers/misc/eeprom/at24.c
+++ b/drivers/misc/eeprom/at24.c
@@ -278,7 +278,7 @@ static ssize_t at24_bin_read(struct kobject *kobj, struct bin_attribute *attr,
  * We only use page mode writes; the alternative is sloooow. This routine
  * writes at most one page.
  */
-static ssize_t at24_eeprom_write(struct at24_data *at24, char *buf,
+static ssize_t at24_eeprom_write(struct at24_data *at24, const char *buf,
 		unsigned offset, size_t count)
 {
 	struct i2c_client *client;
@@ -347,8 +347,8 @@ static ssize_t at24_eeprom_write(struct at24_data *at24, char *buf,
 	return -ETIMEDOUT;
 }
 
-static ssize_t at24_write(struct at24_data *at24,
-		char *buf, loff_t off, size_t count)
+static ssize_t at24_write(struct at24_data *at24, const char *buf, loff_t off,
+			  size_t count)
 {
 	ssize_t retval = 0;
 
@@ -406,7 +406,7 @@ static ssize_t at24_macc_read(struct memory_accessor *macc, char *buf,
 	return at24_read(at24, buf, offset, count);
 }
 
-static ssize_t at24_macc_write(struct memory_accessor *macc, char *buf,
+static ssize_t at24_macc_write(struct memory_accessor *macc, const char *buf,
 			  off_t offset, size_t count)
 {
 	struct at24_data *at24 = container_of(macc, struct at24_data, macc);
-- 
1.6.2.1

