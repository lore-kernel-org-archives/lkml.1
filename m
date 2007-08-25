Return-Path: <linux-kernel-owner+w=401wt.eu-S934540AbXHYTa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934540AbXHYTa2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 15:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761399AbXHYTaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 15:30:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:48294 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758751AbXHYTaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 15:30:19 -0400
Date: Sat, 25 Aug 2007 21:30:14 +0200
From: Karsten Keil <kkeil@suse.de>
To: fernando@oss.ntt.co.jp
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isdn/sc: remove unused REQUEST_IRQ and unnecessary header file
Message-ID: <20070825193014.GA2370@pingi.kke.suse.de>
Mail-Followup-To: fernando@oss.ntt.co.jp,
	Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.27-0.6-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[PATCH] isdn/sc: remove unused REQUEST_IRQ and unnecessary

REQUEST_IRQ is never used, so delete it. In the process get rid of the
macro FREE_IRQ which makes the code unnecessarily difficult to read.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Acked-by: Karsten Keil <kkeil@suse.de>
---

diff -urNp linux-2.6.23-rc3-orig/drivers/isdn/sc/debug.h linux-2.6.23-rc3/drivers/isdn/sc/debug.h
--- linux-2.6.23-rc3-orig/drivers/isdn/sc/debug.h	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.23-rc3/drivers/isdn/sc/debug.h	1970-01-01 09:00:00.000000000 +0900
@@ -1,19 +0,0 @@
-/* $Id: debug.h,v 1.2.8.1 2001/09/23 22:24:59 kai Exp $
- *
- * Copyright (C) 1996  SpellCaster Telecommunications Inc.
- *
- * This software may be used and distributed according to the terms
- * of the GNU General Public License, incorporated herein by reference.
- *
- * For more information, please contact gpl-info@spellcast.com or write:
- *
- *     SpellCaster Telecommunications Inc.
- *     5621 Finch Avenue East, Unit #3
- *     Scarborough, Ontario  Canada
- *     M1B 2T9
- *     +1 (416) 297-8565
- *     +1 (416) 297-6433 Facsimile
- */
-
-#define REQUEST_IRQ(a,b,c,d,e) request_irq(a,b,c,d,e)
-#define FREE_IRQ(a,b) free_irq(a,b)
diff -urNp linux-2.6.23-rc3-orig/drivers/isdn/sc/includes.h linux-2.6.23-rc3/drivers/isdn/sc/includes.h
--- linux-2.6.23-rc3-orig/drivers/isdn/sc/includes.h	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.23-rc3/drivers/isdn/sc/includes.h	2007-08-24 20:55:45.000000000 +0900
@@ -14,4 +14,3 @@
 #include <linux/timer.h>
 #include <linux/wait.h>
 #include <linux/isdnif.h>
-#include "debug.h"
diff -urNp linux-2.6.23-rc3-orig/drivers/isdn/sc/init.c linux-2.6.23-rc3/drivers/isdn/sc/init.c
--- linux-2.6.23-rc3-orig/drivers/isdn/sc/init.c	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.23-rc3/drivers/isdn/sc/init.c	2007-08-24 20:31:58.000000000 +0900
@@ -404,7 +404,7 @@ static void __exit sc_exit(void)
 		/*
 		 * Release the IRQ
 		 */
-		FREE_IRQ(sc_adapter[i]->interrupt, NULL);
+		free_irq(sc_adapter[i]->interrupt, NULL);
 
 		/*
 		 * Reset for a clean start

-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
