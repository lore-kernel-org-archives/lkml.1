Return-Path: <linux-kernel-owner+w=401wt.eu-S934045AbZLFRm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934045AbZLFRm6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 12:42:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934021AbZLFRm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 12:42:57 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:60330 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933998AbZLFRm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 12:42:56 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: trivial@kernel.org
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Borislav Petkov <petkovbb@gmail.com>, Jens Axboe <axboe@kernel.dk>,
       Randy Dunlap <rdunlap@xenotime.net>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH] doc: remove compilation options section from ide-cd documentation
Date: Sun,  6 Dec 2009 15:42:49 -0200
Message-Id: <1260121370-648-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This section pointed out to compilation options which no longer exist.

VERBOSE_IDE_CD_ERRORS has been replace by config option
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS.

STANDARD_ATAPI is no longer needed, since the non-standard drivers, which
required bcd2bin are now detected, and there's a flag for them.

NO_DOOR_LOCKING is now a sysctl parameter for cdrom drivers.

CDROM_NBLOCKS_BUFFER is not used anymore. The READAUDIO is now in cdrom.c and it
allocates as much as user space has requested to read, backing off if it fails.

TEST is not there anymore or in cdrom either. ide allows to send ATA commands
through ioctl, although it may be helpful to send MMC packets through the cdrom
layer directly.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 Documentation/cdrom/ide-cd |   39 ++-------------------------------------
 1 files changed, 2 insertions(+), 37 deletions(-)

diff --git a/Documentation/cdrom/ide-cd b/Documentation/cdrom/ide-cd
index 2c558cd..f4dc9de 100644
--- a/Documentation/cdrom/ide-cd
+++ b/Documentation/cdrom/ide-cd
@@ -159,42 +159,7 @@ two arguments:  the CDROM device, and the slot number to which you wish
 to change.  If the slot number is -1, the drive is unloaded.
 
 
-4. Compilation options
-----------------------
-
-There are a few additional options which can be set when compiling the
-driver.  Most people should not need to mess with any of these; they
-are listed here simply for completeness.  A compilation option can be
-enabled by adding a line of the form `#define <option> 1' to the top
-of ide-cd.c.  All these options are disabled by default.
-
-VERBOSE_IDE_CD_ERRORS
-  If this is set, ATAPI error codes will be translated into textual
-  descriptions.  In addition, a dump is made of the command which
-  provoked the error.  This is off by default to save the memory used
-  by the (somewhat long) table of error descriptions.  
-
-STANDARD_ATAPI
-  If this is set, the code needed to deal with certain drives which do
-  not properly implement the ATAPI spec will be disabled.  If you know
-  your drive implements ATAPI properly, you can turn this on to get a
-  slightly smaller kernel.
-
-NO_DOOR_LOCKING
-  If this is set, the driver will never attempt to lock the door of
-  the drive.
-
-CDROM_NBLOCKS_BUFFER
-  This sets the size of the buffer to be used for a CDROMREADAUDIO
-  ioctl.  The default is 8.
-
-TEST
-  This currently enables an additional ioctl which enables a user-mode
-  program to execute an arbitrary packet command.  See the source for
-  details.  This should be left off unless you know what you're doing.
-
-
-5. Common problems
+4. Common problems
 ------------------
 
 This section discusses some common problems encountered when trying to
@@ -371,7 +336,7 @@ f. Data corruption.
     expense of low system performance.
 
 
-6. cdchange.c
+5. cdchange.c
 -------------
 
 /*
-- 
1.6.3.3

