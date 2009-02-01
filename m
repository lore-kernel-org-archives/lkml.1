Return-Path: <linux-kernel-owner+w=401wt.eu-S1755685AbZBARvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685AbZBARvK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 12:51:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753880AbZBARs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 12:48:59 -0500
Received: from mail-bw0-f12.google.com ([209.85.218.12]:45568 "EHLO
	mail-bw0-f12.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012AbZBARs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 12:48:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=p6j2br2Sp5BF49fyfT17tFJsUfANYvekHmDkKitQaejJxSowuLAQzsNzGr4mhVuDpC
         YveBHqwP+4OIdXCP5y9TUVjgLJ2JUuO499cm+lUfhKY0dac57MP9LT22d4sYEsU8si5f
         +XQ6pRkhUQ9Rv9fWXTjJqxwX/G2hAgwPEAZ9M=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 01 Feb 2009 18:49:51 +0100
Message-Id: <20090201174951.19144.78464.sendpatchset@localhost.localdomain>
In-Reply-To: <20090201174909.19144.67767.sendpatchset@localhost.localdomain>
References: <20090201174909.19144.67767.sendpatchset@localhost.localdomain>
Subject: [PATCH 06/15] ide: remove now superfluous check from ide_host_register()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: remove now superfluous check from ide_host_register()

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1333,20 +1333,15 @@ int ide_host_register(struct ide_host *h
 		ide_init_port_hw(hwif, hws[i]);
 		ide_port_apply_params(hwif);
 
-		if (d == NULL) {
-			mate = NULL;
-		} else {
-			if ((i & 1) && mate) {
-				hwif->mate = mate;
-				mate->mate = hwif;
-			}
-
-			mate = (i & 1) ? NULL : hwif;
-
-			ide_init_port(hwif, i & 1, d);
-			ide_port_cable_detect(hwif);
+		if ((i & 1) && mate) {
+			hwif->mate = mate;
+			mate->mate = hwif;
 		}
 
+		mate = (i & 1) ? NULL : hwif;
+
+		ide_init_port(hwif, i & 1, d);
+		ide_port_cable_detect(hwif);
 		ide_port_init_devices(hwif);
 	}
 
