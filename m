Return-Path: <linux-kernel-owner+w=401wt.eu-S1760864AbZDGUqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760864AbZDGUqr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 16:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756841AbZDGUqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 16:46:38 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:52512 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756369AbZDGUqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 16:46:37 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jean Delvare <khali@linux-fr.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       David Brownell <dbrownell@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/2] at25: make input buffers of at25_*write() const
Date: Tue,  7 Apr 2009 22:44:33 +0200
Message-Id: <1239137073-21353-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1239137073-21353-1-git-send-email-geert@linux-m68k.org>
References: <1239137073-21353-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

| drivers/misc/eeprom/at25.c:358: warning: assignment from incompatible pointer type

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/misc/eeprom/at25.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/eeprom/at25.c b/drivers/misc/eeprom/at25.c
index 6bc0dac..b34cb5f 100644
--- a/drivers/misc/eeprom/at25.c
+++ b/drivers/misc/eeprom/at25.c
@@ -140,7 +140,8 @@ at25_bin_read(struct kobject *kobj, struct bin_attribute *bin_attr,
 
 
 static ssize_t
-at25_ee_write(struct at25_data *at25, char *buf, loff_t off, size_t count)
+at25_ee_write(struct at25_data *at25, const char *buf, loff_t off,
+	      size_t count)
 {
 	ssize_t			status = 0;
 	unsigned		written = 0;
@@ -276,7 +277,7 @@ static ssize_t at25_mem_read(struct memory_accessor *mem, char *buf,
 	return at25_ee_read(at25, buf, offset, count);
 }
 
-static ssize_t at25_mem_write(struct memory_accessor *mem, char *buf,
+static ssize_t at25_mem_write(struct memory_accessor *mem, const char *buf,
 			  off_t offset, size_t count)
 {
 	struct at25_data *at25 = container_of(mem, struct at25_data, mem);
-- 
1.6.2.1

