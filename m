Return-Path: <linux-kernel-owner+w=401wt.eu-S1759300AbXFZW2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759300AbXFZW2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 18:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757362AbXFZW20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 18:28:26 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:30599 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757235AbXFZW20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 18:28:26 -0400
Date: Tue, 26 Jun 2007 15:30:18 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: p.hardwick@option.com, akpm <akpm@linux-foundation.org>
Subject: [PATCH -mm] nozomi: fix section when HOTPLUG=n
Message-Id: <20070626153018.704ae646.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

When CONFIG_HOTPLUG=n, this function needs to be present instead of
discarded.

WARNING: drivers/built-in.o(.text+0x2045f): Section mismatch: reference to .exit.text:tty_exit (between 'nozomi_card_exit' and 'card_type_show')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/char/nozomi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.22-rc4-mm2.orig/drivers/char/nozomi.c
+++ linux-2.6.22-rc4-mm2/drivers/char/nozomi.c
@@ -1636,7 +1636,7 @@ exit:
 	up(&port->tty_sem);
 }
 
-static void __devexit tty_exit(void)
+static void tty_exit(void)
 {
 	struct nozomi *dc = my_dev;
 	int i, ret;
