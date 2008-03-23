Return-Path: <linux-kernel-owner+w=401wt.eu-S1760613AbYCWURN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760613AbYCWURN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 16:17:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756330AbYCWUQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 16:16:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:34528 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755929AbYCWUQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 16:16:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ES3wbhZ/SeyUiAik8kRlCbnK0riLeRMTwQp+D0retCfZl5uMubs/qIDKt+9uuXqZHT78deUqayi+ze+MMFJryKG3xOrk0fScrUOFnIp1xyYZoWl1ZwV9HjPwWrQRXta28xjgvIOZu3bMdXuEEFtVtriekSoGKVv0bhUxE/Y60r4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/3] gayle: add "doubler" parameter
Date: Sun, 23 Mar 2008 21:27:30 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803232127.30323.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add "doubler" parameter to enable support for IDE doublers.

* Obsolete "ide=doubler" kernel parameter.

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 Documentation/ide/ide.txt  |    9 +++------
 drivers/ide/ide.c          |    2 +-
 drivers/ide/legacy/gayle.c |    2 ++
 3 files changed, 6 insertions(+), 7 deletions(-)

Index: b/Documentation/ide/ide.txt
===================================================================
--- a/Documentation/ide/ide.txt
+++ b/Documentation/ide/ide.txt
@@ -181,12 +181,6 @@ driver using the "options=" keyword to i
 Summary of ide driver parameters for kernel command line
 --------------------------------------------------------
 
- "ide=doubler"		: probe/support IDE doublers on Amiga
-
-There may be more options than shown -- use the source, Luke!
-
-Everything else is rejected with a "BAD OPTION" message.
-
 For legacy IDE VLB host drivers (ali14xx/dtc2278/ht6560b/qd65xx/umc8672)
 you need to explicitly enable probing by using "probe" kernel parameter,
 i.e. to enable probing for ALI M14xx chipsets (ali14xx host driver) use:
@@ -203,6 +197,9 @@ are detected automatically).
 You also need to use "probe" kernel parameter for ide-4drives driver
 (support for IDE generic chipset with four drives on one port).
 
+To enable support for IDE doublers on Amiga use "doubler" kernel parameter
+for gayle host driver (i.e. "gayle.doubler" if the driver is built-in).
+
 To force ignoring cable detection (this should be needed only if you're using
 short 40-wires cable which cannot be automatically detected - if this is not
 a case please report it as a bug instead) use "ignore_cable" kernel parameter:
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -717,7 +717,7 @@ static int __init ide_setup(char *s)
 
 		printk(" : Enabled support for IDE doublers\n");
 		ide_doubler = 1;
-		return 1;
+		goto obsolete_option;
 	}
 #endif /* CONFIG_BLK_DEV_IDEDOUBLER */
 
Index: b/drivers/ide/legacy/gayle.c
===================================================================
--- a/drivers/ide/legacy/gayle.c
+++ b/drivers/ide/legacy/gayle.c
@@ -63,6 +63,8 @@
 #define GAYLE_HAS_CONTROL_REG	(!ide_doubler)
 #define GAYLE_IDEREG_SIZE	(ide_doubler ? 0x1000 : 0x2000)
 int ide_doubler = 0;	/* support IDE doublers? */
+module_param_named(doubler, ide_doubler, bool, 0);
+MODULE_PARM_DESC(doubler, "enable support for IDE doublers");
 #endif /* CONFIG_BLK_DEV_IDEDOUBLER */
 
 
