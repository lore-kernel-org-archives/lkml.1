Return-Path: <linux-kernel-owner+w=401wt.eu-S1757548AbYLPTb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbYLPTb7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 14:31:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbYLPTbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 14:31:48 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:64756 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453AbYLPTbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 14:31:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=pOJROu1bzR1SjYBNRTxMLFz6owNgnG7fDMdtEzQgJAGDlHR8eI3fly1iLhJqOxWUYE
         MzN9ew54trQHuQ8F05+ncZ6r73hHjND0O16wwHmTL6kstcPLTzOFkyR3nLZ9twePs1xW
         TwqXvm7NWP4y1e65hilKd6wwP1l38H5A/ExHw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 16 Dec 2008 20:31:37 +0100
Message-Id: <20081216193137.3959.70339.sendpatchset@localhost.localdomain>
Subject: [PATCH 1/9] ide: update ide_unregister() documentation
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: update ide_unregister() documentation

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
just a couple of cleanups, should be applied on a top of Sunday's patchset
[ http://marc.info/?l=linux-kernel&m=122921159918716&w=2 ]

 drivers/ide/ide.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -155,22 +155,14 @@ EXPORT_SYMBOL_GPL(ide_port_unregister_de
  *	ide_unregister		-	free an IDE interface
  *	@hwif: IDE interface
  *
- *	Perform the final unregister of an IDE interface. At the moment
- *	we don't refcount interfaces so this will also get split up.
+ *	Perform the final unregister of an IDE interface.
  *
  *	Locking:
- *	The caller must not hold the IDE locks
- *	The drive present/vanishing is not yet properly locked
- *	Take care with the callbacks. These have been split to avoid
- *	deadlocking the IDE layer. The shutdown callback is called
- *	before we take the lock and free resources. It is up to the
- *	caller to be sure there is no pending I/O here, and that
- *	the interface will not be reopened (present/vanishing locking
- *	isn't yet done BTW). After we commit to the final kill we
- *	call the cleanup callback with the ide locks held.
+ *	The caller must not hold the IDE locks.
  *
- *	Unregister restores the hwif structures to the default state.
- *	This is raving bonkers.
+ *	It is up to the caller to be sure there is no pending I/O here,
+ *	and that the interface will not be reopened (present/vanishing
+ *	locking isn't yet done BTW).
  */
 
 void ide_unregister(ide_hwif_t *hwif)
