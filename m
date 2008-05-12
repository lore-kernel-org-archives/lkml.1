Return-Path: <linux-kernel-owner+w=401wt.eu-S1759332AbYELTHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759332AbYELTHM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 15:07:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757643AbYELTFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 15:05:51 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:42516 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756903AbYELTFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 15:05:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=P/AOLNwPh28/rbehoO4n3JxLJOiT6b8aMGQjY9jHhGhbcFlPpSYBzjkYLfLlGPAMxrZ2lc/iTYBvZBS06GK4FtMLJvjKaczodw/JX8m/Wc9m/Kl9/RPiCXAJC4d2TEAPoQo8w55uZNtkLetNsib/4uO7fNCnpNRMVmODBLy2QRw=
Subject: [PATCH 06/12] kgdb: use the common ascii hex helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 12 May 2008 12:05:39 -0700
Message-Id: <1210619139.24092.57.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/misc/kgdbts.c |    5 ++---
 kernel/kgdb.c         |   10 ++++------
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/misc/kgdbts.c b/drivers/misc/kgdbts.c
index fa39410..2763ae0 100644
--- a/drivers/misc/kgdbts.c
+++ b/drivers/misc/kgdbts.c
@@ -119,7 +119,6 @@
 	} while (0)
 #define MAX_CONFIG_LEN		40
 
-static const char hexchars[] = "0123456789abcdef";
 static struct kgdb_io kgdbts_io_ops;
 static char get_buf[BUFMAX];
 static int get_buf_cnt;
@@ -619,8 +618,8 @@ static void fill_get_buf(char *buf)
 		count++;
 	}
 	strcat(get_buf, "#");
-	get_buf[count + 2] = hexchars[checksum >> 4];
-	get_buf[count + 3] = hexchars[checksum & 0xf];
+	get_buf[count + 2] = hex_asc_hi(checksum);
+	get_buf[count + 3] = hex_asc_lo(checksum);
 	get_buf[count + 4] = '\0';
 	v2printk("get%i: %s\n", ts.idx, get_buf);
 }
diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index 14787de..15c9bb7 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -227,8 +227,6 @@ void __weak kgdb_disable_hw_debug(struct pt_regs *regs)
  * GDB remote protocol parser:
  */
 
-static const char	hexchars[] = "0123456789abcdef";
-
 static int hex(char ch)
 {
 	if ((ch >= 'a') && (ch <= 'f'))
@@ -316,8 +314,8 @@ static void put_packet(char *buffer)
 		}
 
 		kgdb_io_ops->write_char('#');
-		kgdb_io_ops->write_char(hexchars[checksum >> 4]);
-		kgdb_io_ops->write_char(hexchars[checksum & 0xf]);
+		kgdb_io_ops->write_char(hex_asc_hi(checksum));
+		kgdb_io_ops->write_char(hex_asc_lo(checksum));
 		if (kgdb_io_ops->flush)
 			kgdb_io_ops->flush();
 
@@ -478,8 +476,8 @@ static void error_packet(char *pkt, int error)
 {
 	error = -error;
 	pkt[0] = 'E';
-	pkt[1] = hexchars[(error / 10)];
-	pkt[2] = hexchars[(error % 10)];
+	pkt[1] = hex_asc[(error / 10)];
+	pkt[2] = hex_asc[(error % 10)];
 	pkt[3] = '\0';
 }
 
-- 
1.5.5.1.404.g981f6


