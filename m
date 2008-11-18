Return-Path: <linux-kernel-owner+w=401wt.eu-S1753853AbYKRUWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbYKRUWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 15:22:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbYKRUWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 15:22:22 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:60592 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbYKRUWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 15:22:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=kUFNldDXtMwERqx0DxqcHjt46dhuzzGtZwQG3r5tCPZ7oJwxLAZu2kdFPL06bluiV6
         PNyMGNJN9UQ4hsVaAWx8Tg4qrw8yarJ1UcpNB1VrhZ0WdJNq7BYmmx1ob13tXE7n+Cvi
         FxKeLzgZqarATFavTf1suRmmm8ptQZJwJ+FUQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/3] ide: remove "paranoia" checks for hwgroup->busy
Date: Tue, 18 Nov 2008 21:14:29 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org,
       Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Elias Oltmanns <eo@nebensachen.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811182114.29226.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove "paranoia" checks for hwgroup->busy from ide_timer_expiry()
and ide_intr().  This is a preparation for future changes.

Cc: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Elias Oltmanns <eo@nebensachen.de>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
against current pata-2.6 tree (should also apply fine to linux-next)

 drivers/ide/ide-io.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -1018,10 +1018,7 @@ void ide_timer_expiry (unsigned long dat
 		} else {
 			ide_hwif_t *hwif;
 			ide_startstop_t startstop = ide_stopped;
-			if (!hwgroup->busy) {
-				hwgroup->busy = 1;	/* paranoia */
-				printk(KERN_ERR "%s: ide_timer_expiry: hwgroup->busy was 0 ??\n", drive->name);
-			}
+
 			if ((expiry = hwgroup->expiry) != NULL) {
 				/* continue */
 				if ((wait = expiry(drive)) > 0) {
@@ -1234,10 +1231,6 @@ irqreturn_t ide_intr (int irq, void *dev
 		 */
 		goto out;
 
-	if (!hwgroup->busy) {
-		hwgroup->busy = 1;	/* paranoia */
-		printk(KERN_ERR "%s: ide_intr: hwgroup->busy was 0 ??\n", drive->name);
-	}
 	hwgroup->handler = NULL;
 	hwgroup->req_gen++;
 	del_timer(&hwgroup->timer);
