Return-Path: <linux-kernel-owner+w=401wt.eu-S1751891AbXFGOUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891AbXFGOUy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 10:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751100AbXFGOUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 10:20:48 -0400
Received: from mx.melware.net ([217.91.97.190]:3526 "EHLO mx.melware.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbXFGOUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 10:20:47 -0400
X-Greylist: delayed 1114 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Jun 2007 10:20:46 EDT
Date: Thu, 7 Jun 2007 16:02:11 +0200 (CEST)
From: Armin Schindler <armin@melware.de>
X-X-Sender: armin@phoenix.one.melware.de
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       kkeil@suse.de
Subject: Re: [PATCH] isdn/diva: fix section mismatch
In-Reply-To: <20070606142045.3bd15032.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.61.0706071558110.7490@phoenix.one.melware.de>
References: <20070606142045.3bd15032.randy.dunlap@oracle.com>
Organization: Cytronics & Melware
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

__exit function is used by both init and exit routines, so it cannot
be marked __init.  (from allyesconfig)

WARNING: drivers/built-in.o(.text+0x9b83cf): Section mismatch: reference to .exit.text: (between 'divasfunc_exit' and 'didd_callback')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Armin Schindler <armin@melware.de>
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
 

