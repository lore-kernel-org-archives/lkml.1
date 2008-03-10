Return-Path: <linux-kernel-owner+w=401wt.eu-S1757209AbYCJXfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209AbYCJXfg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 19:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753606AbYCJXem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 19:34:42 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:64224 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbYCJXej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 19:34:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=FwzxfMg1QwUPvWGLFp6cRTDg4+jlMfLKI1z0YUz9gNPoQw8g68cY+CzJKxl6FXXGbzRCKaDF/NeFtV2T/PZRvyXxgaoYlrGLiurjtX99p3CxX9APKp977XjMo6DycwSeIiZQUNTyu/sPFdxXZyIcuNdR++6gLAlNdbZXk2IA3oE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 4/5] ide: remove obsoleted "idex=serialize" kernel parameter
Date: Tue, 11 Mar 2008 00:47:54 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803110047.54837.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove obsoleted "idex=serialize" kernel parameter
(it has been obsoleted since 1 Nov 2004).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 Documentation/ide/ide.txt |    5 -----
 drivers/ide/ide.c         |    9 ++-------
 2 files changed, 2 insertions(+), 12 deletions(-)

Index: b/Documentation/ide/ide.txt
===================================================================
--- a/Documentation/ide/ide.txt
+++ b/Documentation/ide/ide.txt
@@ -235,11 +235,6 @@ Summary of ide driver parameters for ker
 			  As for VLB, it is safest to not specify it.
 			  Bigger values are safer than smaller ones.
 
- "idex=serialize"	: do not overlap operations on idex. Please note
-			  that you will have to specify this option for
-			  both the respective primary and secondary channel
-			  to take effect.
-
  "idex=reset"		: reset interface after probe
 
  "ide=reverse"		: formerly called to pci sub-system, but now local.
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -1005,7 +1005,7 @@ static int __init ide_setup(char *s)
 		 * (-8, -9, -10) are reserved to ease the hardcoding.
 		 */
 		static const char *ide_words[] = {
-			"minus1", "serialize", "minus3", "minus4",
+			"minus1", "minus2", "minus3", "minus4",
 			"reset", "minus6", "ata66", "minus8", "minus9",
 			"minus10", "four", "qd65xx", "ht6560b", "cmd640_vlb",
 			"dtc2278", "umc8672", "ali14xx", NULL };
@@ -1091,12 +1091,7 @@ static int __init ide_setup(char *s)
 			case -5: /* "reset" */
 				hwif->reset = 1;
 				goto obsolete_option;
-			case -2: /* "serialize" */
-				hwif->mate = &ide_hwifs[hw^1];
-				hwif->mate->mate = hwif;
-				hwif->serialized = hwif->mate->serialized = 1;
-				goto obsolete_option;
-
+			case -2:
 			case -1:
 			case 0:
 			case 1:
