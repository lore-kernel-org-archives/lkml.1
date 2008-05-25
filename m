Return-Path: <linux-kernel-owner+w=401wt.eu-S1761106AbYEYLhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761106AbYEYLhc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 07:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755642AbYEYLhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 07:37:08 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:47812 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901AbYEYLhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 07:37:06 -0400
Date: Sun, 25 May 2008 07:37:03 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] SERIAL:  Simplify code using ARRAY_SIZE() macro.
Message-ID: <alpine.LFD.1.10.0805250735560.23325@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

 drivers/serial/68328serial.c |    6 +++---
 drivers/serial/mcfserial.c   |    5 ++---
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/serial/68328serial.c b/drivers/serial/68328serial.c
index bbf5bc5..71c56c1 100644
--- a/drivers/serial/68328serial.c
+++ b/drivers/serial/68328serial.c
@@ -154,7 +154,7 @@ static int baud_table[] = {
 	0, 50, 75, 110, 134, 150, 200, 300, 600, 1200, 1800, 2400, 4800,
 	9600, 19200, 38400, 57600, 115200, 0 };

-#define BAUD_TABLE_SIZE (sizeof(baud_table)/sizeof(baud_table[0]))
+#define BAUD_TABLE_SIZE ARRAY_SIZE(baud_table)

 /* Sets or clears DTR/RTS on the requested line */
 static inline void m68k_rtsdtr(struct m68k_serial *ss, int set)
@@ -1413,10 +1413,10 @@ static void m68328_set_baud(void)
 	USTCNT = ustcnt & ~USTCNT_TXEN;

 again:
-	for (i = 0; i < sizeof(baud_table) / sizeof(baud_table[0]); i++)
+	for (i = 0; i < BAUD_TABLE_SIZE); i++)
 		if (baud_table[i] == m68328_console_baud)
 			break;
-	if (i >= sizeof(baud_table) / sizeof(baud_table[0])) {
+	if (i >= BAUD_TABLE_SIZE) {
 		m68328_console_baud = 9600;
 		goto again;
 	}
diff --git a/drivers/serial/mcfserial.c b/drivers/serial/mcfserial.c
index 56007cc..a0699ba 100644
--- a/drivers/serial/mcfserial.c
+++ b/drivers/serial/mcfserial.c
@@ -137,7 +137,7 @@ static struct mcf_serial mcfrs_table[] = {
 };


-#define	NR_PORTS	(sizeof(mcfrs_table) / sizeof(struct mcf_serial))
+#define	NR_PORTS	ARRAY_SIZE(mcfrs_table)

 /*
  * This is used to figure out the divisor speeds and the timeouts.
@@ -146,8 +146,7 @@ static int mcfrs_baud_table[] = {
 	0, 50, 75, 110, 134, 150, 200, 300, 600, 1200, 1800, 2400, 4800,
 	9600, 19200, 38400, 57600, 115200, 230400, 460800, 0
 };
-#define MCFRS_BAUD_TABLE_SIZE \
-			(sizeof(mcfrs_baud_table)/sizeof(mcfrs_baud_table[0]))
+#define MCFRS_BAUD_TABLE_SIZE ARRAY_SIZE(mcfrs_baud_table)


 #ifdef CONFIG_MAGIC_SYSRQ


========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
