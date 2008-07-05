Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbYGEN31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbYGEN31 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 09:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753455AbYGEN3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 09:29:20 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:57571 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbYGEN3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 09:29:19 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 2/4] Char: ip2, cleanup globals
Date: Sat,  5 Jul 2008 15:28:24 +0200
Message-Id: <1215264506-32455-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1215264506-32455-1-git-send-email-jirislaby@gmail.com>
References: <1215264506-32455-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- do not init .bss zeroed data to zero again (by memset or
  explicit assignment)
- use char [] instead of char * for string constants

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/ip2/ip2main.c |   18 +++++++-----------
 1 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
index 8ac1dfe..4174c65 100644
--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -150,12 +150,12 @@ static int ip2_read_proc(char *, char **, off_t, int, int *, void * );
 /*************/
 
 /* String constants to identify ourselves */
-static char *pcName    = "Computone IntelliPort Plus multiport driver";
-static char *pcVersion = "1.2.14";
+static const char pcName[] = "Computone IntelliPort Plus multiport driver";
+static const char pcVersion[] = "1.2.14";
 
 /* String constants for port names */
-static char *pcDriver_name   = "ip2";
-static char *pcIpl    		 = "ip2ipl";
+static const char pcDriver_name[] = "ip2";
+static const char pcIpl[] = "ip2ipl";
 
 /***********************/
 /* Function Prototypes */
@@ -237,8 +237,8 @@ static const struct file_operations ip2_ipl = {
 	.open		= ip2_ipl_open,
 }; 
 
-static unsigned long irq_counter = 0;
-static unsigned long bh_counter = 0;
+static unsigned long irq_counter;
+static unsigned long bh_counter;
 
 // Use immediate queue to service interrupts
 #define USE_IQI
@@ -286,7 +286,7 @@ MODULE_AUTHOR("Doug McNash");
 MODULE_DESCRIPTION("Computone IntelliPort Plus Driver");
 MODULE_LICENSE("GPL");
 
-static int poll_only = 0;
+static int poll_only;
 
 static int Eisa_irq;
 static int Eisa_slot;
@@ -613,10 +613,6 @@ static int ip2_loadmain(void)
 	/* Initialise the iiEllis subsystem. */
 	iiEllisInit();
 
-	/* Initialize arrays. */
-	memset( i2BoardPtrTable, 0, sizeof i2BoardPtrTable );
-	memset( DevTable, 0, sizeof DevTable );
-
 	/* Initialise all the boards we can find (up to the maximum). */
 	for ( i = 0; i < IP2_MAX_BOARDS; ++i ) {
 		switch ( ip2config.addr[i] ) { 
-- 
1.5.5.1

