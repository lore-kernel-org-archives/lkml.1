Return-Path: <linux-kernel-owner+w=401wt.eu-S1754811AbZGSPaD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbZGSPaD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 11:30:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754709AbZGSPaC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 11:30:02 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:57899 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754649AbZGSPaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 11:30:00 -0400
Date: Sun, 19 Jul 2009 17:29:57 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: mdharm-usb@one-eyed-alien.net, linux-usb@vger.kernel.org,
       usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 8/10] drivers/usb/storage: Drop an unneeded a NULL test
Message-ID: <Pine.LNX.4.64.0907191729380.16542@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In each case, the NULL test is not necessary because the function is static
and at the only places where it is called, the us argument has already been
dereferenced.

The semantic patch that finds the problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T;
expression E,E1;
identifier i,fld;
statement S;
@@

- T i = E->fld;
+ T i;
  ... when != E=E1
      when != i
  if (E == NULL||...) S
+ i = E->fld;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/usb/storage/datafab.c  |    4 ++--
 drivers/usb/storage/jumpshot.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/storage/datafab.c b/drivers/usb/storage/datafab.c
index 2b6e565..ded836b 100644
--- a/drivers/usb/storage/datafab.c
+++ b/drivers/usb/storage/datafab.c
@@ -334,7 +334,7 @@ static int datafab_determine_lun(struct us_data *us,
 	unsigned char *buf;
 	int count = 0, rc;
 
-	if (!us || !info)
+	if (!info)
 		return USB_STOR_TRANSPORT_ERROR;
 
 	memcpy(command, scommand, 8);
@@ -399,7 +399,7 @@ static int datafab_id_device(struct us_data *us,
 	unsigned char *reply;
 	int rc;
 
-	if (!us || !info)
+	if (!info)
 		return USB_STOR_TRANSPORT_ERROR;
 
 	if (info->lun == -1) {
diff --git a/drivers/usb/storage/jumpshot.c b/drivers/usb/storage/jumpshot.c
index 1c69420..6168596 100644
--- a/drivers/usb/storage/jumpshot.c
+++ b/drivers/usb/storage/jumpshot.c
@@ -335,7 +335,7 @@ static int jumpshot_id_device(struct us_data *us,
 	unsigned char *reply;
 	int 	 rc;
 
-	if (!us || !info)
+	if (!info)
 		return USB_STOR_TRANSPORT_ERROR;
 
 	command[0] = 0xE0;
