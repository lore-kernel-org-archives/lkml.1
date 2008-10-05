Return-Path: <linux-kernel-owner+w=401wt.eu-S1757115AbYJEQKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115AbYJEQKl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756448AbYJEQG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:06:57 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54866 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756434AbYJEQG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:06:56 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 17/76] ip2, cleanup globals
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:06:56 +0100
Message-ID: <20081005160654.1997.94820.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

- do not init .bss zeroed data to zero again (by memset or
  explicit assignment)
- use char [] instead of char * for string constants

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/ip2/ip2main.c |   18 +++++++-----------
 1 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
index 79bca61..1d46284 100644
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
@@ -615,10 +615,6 @@ static int ip2_loadmain(void)
 	/* Initialise the iiEllis subsystem. */
 	iiEllisInit();
 
-	/* Initialize arrays. */
-	memset( i2BoardPtrTable, 0, sizeof i2BoardPtrTable );
-	memset( DevTable, 0, sizeof DevTable );
-
 	/* Initialise all the boards we can find (up to the maximum). */
 	for ( i = 0; i < IP2_MAX_BOARDS; ++i ) {
 		switch ( ip2config.addr[i] ) { 

