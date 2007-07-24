Return-Path: <linux-kernel-owner+w=401wt.eu-S1763524AbXGXST4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763524AbXGXST4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 14:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbXGXSTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 14:19:49 -0400
Received: from xyzzy.farnsworth.org ([65.39.95.219]:2425 "HELO farnsworth.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751274AbXGXSTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 14:19:48 -0400
From: "Dale Farnsworth" <dale@farnsworth.org>
Date: Tue, 24 Jul 2007 11:19:47 -0700
To: Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org
Subject: [PATCH 10/11] mv64x60_wdt: disable watchdog timer when driver is probed
Message-ID: <20070724181947.GJ27445@xyzzy.farnsworth.org>
References: <20070724180738.GA27445@xyzzy.farnsworth.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070724180738.GA27445@xyzzy.farnsworth.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dale Farnsworth <dale@farnsworth.org>
---
 drivers/char/watchdog/mv64x60_wdt.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6-powerpc-wdt/drivers/char/watchdog/mv64x60_wdt.c
===================================================================
--- linux-2.6-powerpc-wdt.orig/drivers/char/watchdog/mv64x60_wdt.c	2007-07-20 19:33:30.000000000 +0000
+++ linux-2.6-powerpc-wdt/drivers/char/watchdog/mv64x60_wdt.c	2007-07-20 19:34:23.000000000 +0000
@@ -262,6 +262,8 @@ static int __devinit mv64x60_wdt_probe(s
 
 	mv64x60_wdt_set_timeout(timeout);
 
+	mv64x60_wdt_handler_disable();	/* in case timer was already running */
+
 	return misc_register(&mv64x60_wdt_miscdev);
 }
 

