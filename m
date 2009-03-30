Return-Path: <linux-kernel-owner+w=401wt.eu-S1754449AbZC3Ihi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449AbZC3Ihi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 04:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753751AbZC3Ih3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 04:37:29 -0400
Received: from gw01.mail.saunalahti.fi ([195.197.172.115]:45326 "EHLO
	gw01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbZC3Ih2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 04:37:28 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
To: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Cc: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
Subject: [PATCH 1/1] ide: add missing include into drivers/ide/ide-atapi.c
Date: Mon, 30 Mar 2009 11:37:09 +0300
Message-Id: <1238402229-19824-1-git-send-email-dmitri.vorobiev@movial.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A missing include in drivers/ide/ide-atapi.c has produced the following
build error on MIPS:

  CC      drivers/ide/ide-atapi.o
drivers/ide/ide-atapi.c: In function 'ide_io_buffers':
drivers/ide/ide-atapi.c:86: error: implicit declaration of function 'sg_page'
drivers/ide/ide-atapi.c:86: warning: passing argument 1 of 'PageHighMem'
makes pointer from integer without a cast
drivers/ide/ide-atapi.c:90: warning: passing argument 1 of 'kmap_atomic'
makes pointer from integer without a cast
drivers/ide/ide-atapi.c:95: error: implicit declaration of function 'sg_virt'
drivers/ide/ide-atapi.c:95: warning: assignment makes pointer from
integer without a cast
drivers/ide/ide-atapi.c:106: error: implicit declaration of function 'sg_next'
drivers/ide/ide-atapi.c:106: warning: assignment makes pointer from
integer without a cast
make[2]: *** [drivers/ide/ide-atapi.o] Error 1
make[1]: *** [drivers/ide] Error 2
make: *** [drivers] Error 2

This patch adds the missing include and fixes the build error above.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
---
 drivers/ide/ide-atapi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 6adc5b4..97f116f 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -6,6 +6,7 @@
 #include <linux/cdrom.h>
 #include <linux/delay.h>
 #include <linux/ide.h>
+#include <linux/scatterlist.h>
 #include <scsi/scsi.h>
 
 #ifdef DEBUG
-- 
1.5.6.3

