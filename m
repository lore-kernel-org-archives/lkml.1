Return-Path: <linux-kernel-owner+w=401wt.eu-S1755073AbZKELcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073AbZKELcj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 06:32:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753936AbZKELcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 06:32:39 -0500
Received: from compulab.co.il ([67.18.134.219]:33323 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753904AbZKELci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 06:32:38 -0500
Message-ID: <4AF2B7D8.1010903@compulab.co.il>
Date: Thu, 05 Nov 2009 13:32:40 +0200
From: Denis Turischev <denis@compulab.co.il>
User-Agent: Thunderbird 2.0.0.19 (X11/20090114)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Mike Rapoport <mike@compulab.co.il>, Wim Van Sebroeck <wim@iguana.be>,
       Andrey Panin <pazke@centrinvest.ru>
Subject: SBC-FITPC2 watchdog driver fix
References: <4A6492EB.1080709@compulab.co.il>
In-Reply-To: <4A6492EB.1080709@compulab.co.il>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denis Turischev <denis@compulab.co.il>

This patch fixes device registration process.

diff -Nru linux-2.6.32-rc6.orig/drivers/watchdog/sbc_fitpc2_wdt.c
linux-2.6.32-rc6/drivers/watchdog/sbc_fitpc2_wdt.c
--- linux-2.6.32-rc6.orig/drivers/watchdog/sbc_fitpc2_wdt.c    
2009-11-03 21:37:49.000000000 +0200
+++ linux-2.6.32-rc6/drivers/watchdog/sbc_fitpc2_wdt.c  2009-11-05
13:23:11.000000000 +0200
@@ -227,7 +227,7 @@
        }

        err = misc_register(&fitpc2_wdt_miscdev);
-       if (!err) {
+       if (err) {
                pr_err("cannot register miscdev on minor=%d (err=%d)\n",
                                                        WATCHDOG_MINOR,
err);
                goto err_margin;
