Return-Path: <linux-kernel-owner+w=401wt.eu-S935729AbXFFVVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935729AbXFFVVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 17:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935080AbXFFVVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 17:21:09 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:12813 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934970AbXFFVVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 17:21:08 -0400
Date: Wed, 6 Jun 2007 14:20:45 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: mac@melware.de, akpm <akpm@linux-foundation.org>, kkeil@suse.de
Subject: [PATCH] isdn/diva: fix section mismatch
Message-Id: <20070606142045.3bd15032.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

__exit function is used by both init and exit routines, so it cannot
be marked __init.  (from allyesconfig)

WARNING: drivers/built-in.o(.text+0x9b83cf): Section mismatch: reference to .exit.text: (between 'divasfunc_exit' and 'didd_callback')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/isdn/hardware/eicon/divasfunc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2622-rc4.orig/drivers/isdn/hardware/eicon/divasfunc.c
+++ linux-2622-rc4/drivers/isdn/hardware/eicon/divasfunc.c
@@ -195,7 +195,7 @@ static int DIVA_INIT_FUNCTION connect_di
 /*
  * disconnect from didd
  */
-static void DIVA_EXIT_FUNCTION disconnect_didd(void)
+static void disconnect_didd(void)
 {
 	IDI_SYNC_REQ req;
 
