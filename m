Return-Path: <linux-kernel-owner+w=401wt.eu-S1765633AbXHXMwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765633AbXHXMwu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 08:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765401AbXHXMwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 08:52:05 -0400
Received: from serv1.oss.ntt.co.jp ([222.151.198.98]:33866 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762032AbXHXMwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 08:52:03 -0400
Message-ID: <1159.172.50.1.28.1187959920.squirrel@172.19.0.2>
In-Reply-To: <20070824093355.GZ30705@stusta.de>
References: <1187947647.2570.11.camel@sebastian.kern.oss.ntt.co.jp>
    <20070824093355.GZ30705@stusta.de>
Date: Fri, 24 Aug 2007 21:52:00 +0900 (JST)
Subject: Re: [PATCH] isdn/sc: remove unused REQUEST_IRQ and unnecessary 
     header file
From: fernando@oss.ntt.co.jp
To: "Adrian Bunk" <bunk@kernel.org>
Cc: fernando@oss.ntt.co.jp, linux-kernel@vger.kernel.org, kkeil@suse.de
User-Agent: SquirrelMail/1.4.8-2.el4
MIME-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20070824215200_57250"
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_20070824215200_57250
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

On Fri, August 24, 2007 6:33 pm, Adrian Bunk wrote:
> On Fri, Aug 24, 2007 at 06:27:27PM +0900, Fernando Luis Vazquez Cao
> wrote:
>
>> REQUEST_IRQ is never used, so delete it. In the process get rid of the
>> macro FREE_IRQ which makes the code unnecessarily difficult to read.
>
> The header you remove get's #include'd somewhere - and this #include
> must be removed or your patch creates a compile error.
Bummer. Thank you for the catch Adrian. Attaching compile-tested patch.

Fernando

------=_20070824215200_57250
Content-Type: text/plain; name="remove-REQUEST_IRQ.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="remove-REQUEST_IRQ.patch"

[PATCH] isdn/sc: remove unused REQUEST_IRQ and unnecessary

REQUEST_IRQ is never used, so delete it. In the process get rid of the
macro FREE_IRQ which makes the code unnecessarily difficult to read.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
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
------=_20070824215200_57250--


