Return-Path: <linux-kernel-owner+w=401wt.eu-S1759350AbYBUSQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350AbYBUSQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 13:16:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754328AbYBUSQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 13:16:19 -0500
Received: from qb-out-0506.google.com ([72.14.204.238]:22517 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689AbYBUSQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 13:16:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=okmlfLgq6C32/B9gFdQPDid/QtMLw+zQBeND9cSFCt+8MCwtxIra6rTKIEzgs1ew+Q8VzMEb9IsOHtMpZQ7owVOimKL+14w9fF4E4uTs4es3wB8/h4LfeYqR5ASzQhhuJu6nDNdf9VsIJUQKeDzpztnm2PXdU4JTMuCoCZzrWT0=
Subject: [PATCH] avm: fix sparse warning using integer as NULL pointer
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 21 Feb 2008 10:16:31 -0800
Message-Id: <1203617791.20345.49.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/isdn/hardware/avm/b1isa.c:206:37: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/b1isa.c:208:33: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/b1.c:664:42: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/b1.c:666:44: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/b1.c:668:42: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/b1.c:791:37: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/b1.c:793:33: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/b1pci.c:385:37: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/b1pci.c:387:33: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/b1dma.c:886:42: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/b1dma.c:888:44: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/b1dma.c:890:42: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/b1dma.c:973:37: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/b1dma.c:975:33: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/b1pcmcia.c:204:37: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/b1pcmcia.c:206:33: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/t1isa.c:554:37: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/t1isa.c:556:33: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/t1pci.c:236:37: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/t1pci.c:238:33: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/c4.c:1091:42: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/c4.c:1093:44: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/c4.c:1095:42: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/c4.c:1170:21: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/c4.c:1294:37: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/avm/c4.c:1296:33: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/isdn/hardware/avm/b1.c       |   10 +++++-----
 drivers/isdn/hardware/avm/b1dma.c    |   10 +++++-----
 drivers/isdn/hardware/avm/b1isa.c    |    4 ++--
 drivers/isdn/hardware/avm/b1pci.c    |    4 ++--
 drivers/isdn/hardware/avm/b1pcmcia.c |    4 ++--
 drivers/isdn/hardware/avm/c4.c       |   12 ++++++------
 drivers/isdn/hardware/avm/t1isa.c    |    4 ++--
 drivers/isdn/hardware/avm/t1pci.c    |    4 ++--
 8 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/isdn/hardware/avm/b1.c b/drivers/isdn/hardware/avm/b1.c
index 4484a64..abf05ec 100644
--- a/drivers/isdn/hardware/avm/b1.c
+++ b/drivers/isdn/hardware/avm/b1.c
@@ -661,11 +661,11 @@ int b1ctl_read_proc(char *page, char **start, off_t off,
 	len += sprintf(page+len, "%-16s %s\n", "type", s);
 	if (card->cardtype == avm_t1isa)
 	   len += sprintf(page+len, "%-16s %d\n", "cardnr", card->cardnr);
-	if ((s = cinfo->version[VER_DRIVER]) != 0)
+	if ((s = cinfo->version[VER_DRIVER]) != NULL)
 	   len += sprintf(page+len, "%-16s %s\n", "ver_driver", s);
-	if ((s = cinfo->version[VER_CARDTYPE]) != 0)
+	if ((s = cinfo->version[VER_CARDTYPE]) != NULL)
 	   len += sprintf(page+len, "%-16s %s\n", "ver_cardtype", s);
-	if ((s = cinfo->version[VER_SERIAL]) != 0)
+	if ((s = cinfo->version[VER_SERIAL]) != NULL)
 	   len += sprintf(page+len, "%-16s %s\n", "ver_serial", s);
 
 	if (card->cardtype != avm_m1) {
@@ -788,9 +788,9 @@ static int __init b1_init(void)
 	char *p;
 	char rev[32];
 
-	if ((p = strchr(revision, ':')) != 0 && p[1]) {
+	if ((p = strchr(revision, ':')) != NULL && p[1]) {
 		strlcpy(rev, p + 2, 32);
-		if ((p = strchr(rev, '$')) != 0 && p > rev)
+		if ((p = strchr(rev, '$')) != NULL && p > rev)
 		   *(p-1) = 0;
 	} else
 		strcpy(rev, "1.0");
diff --git a/drivers/isdn/hardware/avm/b1dma.c b/drivers/isdn/hardware/avm/b1dma.c
index 669f6f6..da34b98 100644
--- a/drivers/isdn/hardware/avm/b1dma.c
+++ b/drivers/isdn/hardware/avm/b1dma.c
@@ -883,11 +883,11 @@ int b1dmactl_read_proc(char *page, char **start, off_t off,
 	default: s = "???"; break;
 	}
 	len += sprintf(page+len, "%-16s %s\n", "type", s);
-	if ((s = cinfo->version[VER_DRIVER]) != 0)
+	if ((s = cinfo->version[VER_DRIVER]) != NULL)
 	   len += sprintf(page+len, "%-16s %s\n", "ver_driver", s);
-	if ((s = cinfo->version[VER_CARDTYPE]) != 0)
+	if ((s = cinfo->version[VER_CARDTYPE]) != NULL)
 	   len += sprintf(page+len, "%-16s %s\n", "ver_cardtype", s);
-	if ((s = cinfo->version[VER_SERIAL]) != 0)
+	if ((s = cinfo->version[VER_SERIAL]) != NULL)
 	   len += sprintf(page+len, "%-16s %s\n", "ver_serial", s);
 
 	if (card->cardtype != avm_m1) {
@@ -970,9 +970,9 @@ static int __init b1dma_init(void)
 	char *p;
 	char rev[32];
 
-	if ((p = strchr(revision, ':')) != 0 && p[1]) {
+	if ((p = strchr(revision, ':')) != NULL && p[1]) {
 		strlcpy(rev, p + 2, sizeof(rev));
-		if ((p = strchr(rev, '$')) != 0 && p > rev)
+		if ((p = strchr(rev, '$')) != NULL && p > rev)
 		   *(p-1) = 0;
 	} else
 		strcpy(rev, "1.0");
diff --git a/drivers/isdn/hardware/avm/b1isa.c b/drivers/isdn/hardware/avm/b1isa.c
index 80fb488..1e288ee 100644
--- a/drivers/isdn/hardware/avm/b1isa.c
+++ b/drivers/isdn/hardware/avm/b1isa.c
@@ -203,9 +203,9 @@ static int __init b1isa_init(void)
 	char rev[32];
 	int i;
 
-	if ((p = strchr(revision, ':')) != 0 && p[1]) {
+	if ((p = strchr(revision, ':')) != NULL && p[1]) {
 		strlcpy(rev, p + 2, 32);
-		if ((p = strchr(rev, '$')) != 0 && p > rev)
+		if ((p = strchr(rev, '$')) != NULL && p > rev)
 		   *(p-1) = 0;
 	} else
 		strcpy(rev, "1.0");
diff --git a/drivers/isdn/hardware/avm/b1pci.c b/drivers/isdn/hardware/avm/b1pci.c
index 90e2e66..5b314a2 100644
--- a/drivers/isdn/hardware/avm/b1pci.c
+++ b/drivers/isdn/hardware/avm/b1pci.c
@@ -382,9 +382,9 @@ static int __init b1pci_init(void)
 	char rev[32];
 	int err;
 
-	if ((p = strchr(revision, ':')) != 0 && p[1]) {
+	if ((p = strchr(revision, ':')) != NULL && p[1]) {
 		strlcpy(rev, p + 2, 32);
-		if ((p = strchr(rev, '$')) != 0 && p > rev)
+		if ((p = strchr(rev, '$')) != NULL && p > rev)
 		   *(p-1) = 0;
 	} else
 		strcpy(rev, "1.0");
diff --git a/drivers/isdn/hardware/avm/b1pcmcia.c b/drivers/isdn/hardware/avm/b1pcmcia.c
index e479c0a..7740403 100644
--- a/drivers/isdn/hardware/avm/b1pcmcia.c
+++ b/drivers/isdn/hardware/avm/b1pcmcia.c
@@ -201,9 +201,9 @@ static int __init b1pcmcia_init(void)
 	char *p;
 	char rev[32];
 
-	if ((p = strchr(revision, ':')) != 0 && p[1]) {
+	if ((p = strchr(revision, ':')) != NULL && p[1]) {
 		strlcpy(rev, p + 2, 32);
-		if ((p = strchr(rev, '$')) != 0 && p > rev)
+		if ((p = strchr(rev, '$')) != NULL && p > rev)
 		   *(p-1) = 0;
 	} else
 		strcpy(rev, "1.0");
diff --git a/drivers/isdn/hardware/avm/c4.c b/drivers/isdn/hardware/avm/c4.c
index 4bbbbe6..9df1d3f 100644
--- a/drivers/isdn/hardware/avm/c4.c
+++ b/drivers/isdn/hardware/avm/c4.c
@@ -1088,11 +1088,11 @@ static int c4_read_proc(char *page, char **start, off_t off,
 	default: s = "???"; break;
 	}
 	len += sprintf(page+len, "%-16s %s\n", "type", s);
-	if ((s = cinfo->version[VER_DRIVER]) != 0)
+	if ((s = cinfo->version[VER_DRIVER]) != NULL)
 	   len += sprintf(page+len, "%-16s %s\n", "ver_driver", s);
-	if ((s = cinfo->version[VER_CARDTYPE]) != 0)
+	if ((s = cinfo->version[VER_CARDTYPE]) != NULL)
 	   len += sprintf(page+len, "%-16s %s\n", "ver_cardtype", s);
-	if ((s = cinfo->version[VER_SERIAL]) != 0)
+	if ((s = cinfo->version[VER_SERIAL]) != NULL)
 	   len += sprintf(page+len, "%-16s %s\n", "ver_serial", s);
 
 	if (card->cardtype != avm_m1) {
@@ -1167,7 +1167,7 @@ static int c4_add_card(struct capicardparams *p, struct pci_dev *dev,
 	}
 
 	card->mbase = ioremap(card->membase, 128);
-	if (card->mbase == 0) {
+	if (card->mbase == NULL) {
 		printk(KERN_NOTICE "c4: can't remap memory at 0x%lx\n",
 		       card->membase);
 		retval = -EIO;
@@ -1291,9 +1291,9 @@ static int __init c4_init(void)
 	char rev[32];
 	int err;
 
-	if ((p = strchr(revision, ':')) != 0 && p[1]) {
+	if ((p = strchr(revision, ':')) != NULL && p[1]) {
 		strlcpy(rev, p + 2, 32);
-		if ((p = strchr(rev, '$')) != 0 && p > rev)
+		if ((p = strchr(rev, '$')) != NULL && p > rev)
 		   *(p-1) = 0;
 	} else
 		strcpy(rev, "1.0");
diff --git a/drivers/isdn/hardware/avm/t1isa.c b/drivers/isdn/hardware/avm/t1isa.c
index 6130724..e772449 100644
--- a/drivers/isdn/hardware/avm/t1isa.c
+++ b/drivers/isdn/hardware/avm/t1isa.c
@@ -551,9 +551,9 @@ static int __init t1isa_init(void)
 	char *p;
 	int i;
 
-	if ((p = strchr(revision, ':')) != 0 && p[1]) {
+	if ((p = strchr(revision, ':')) != NULL && p[1]) {
 		strlcpy(rev, p + 2, 32);
-		if ((p = strchr(rev, '$')) != 0 && p > rev)
+		if ((p = strchr(rev, '$')) != NULL && p > rev)
 		   *(p-1) = 0;
 	} else
 		strcpy(rev, "1.0");
diff --git a/drivers/isdn/hardware/avm/t1pci.c b/drivers/isdn/hardware/avm/t1pci.c
index d1e253c..e6d298d 100644
--- a/drivers/isdn/hardware/avm/t1pci.c
+++ b/drivers/isdn/hardware/avm/t1pci.c
@@ -233,9 +233,9 @@ static int __init t1pci_init(void)
 	char rev[32];
 	int err;
 
-	if ((p = strchr(revision, ':')) != 0 && p[1]) {
+	if ((p = strchr(revision, ':')) != NULL && p[1]) {
 		strlcpy(rev, p + 2, 32);
-		if ((p = strchr(rev, '$')) != 0 && p > rev)
+		if ((p = strchr(rev, '$')) != NULL && p > rev)
 		   *(p-1) = 0;
 	} else
 		strcpy(rev, "1.0");
-- 
1.5.4.2.200.g99e75



