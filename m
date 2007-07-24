Return-Path: <linux-kernel-owner+w=401wt.eu-S1764352AbXGXSQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764352AbXGXSQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 14:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759121AbXGXSQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 14:16:31 -0400
Received: from xyzzy.farnsworth.org ([65.39.95.219]:3147 "HELO farnsworth.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758194AbXGXSQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 14:16:30 -0400
From: "Dale Farnsworth" <dale@farnsworth.org>
Date: Tue, 24 Jul 2007 11:16:29 -0700
To: Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org
Subject: [PATCH 07/11] mv64x60_wdt: Add WDIOC_SETOPTIONS ioctl support
Message-ID: <20070724181629.GG27445@xyzzy.farnsworth.org>
References: <20070724180738.GA27445@xyzzy.farnsworth.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070724180738.GA27445@xyzzy.farnsworth.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the watchdog timer to be enabled or disabled via the
WDIOC_SETOPTIONS ioctl.

Signed-off-by: Dale Farnsworth <dale@farnsworth.org>
---
 drivers/char/watchdog/mv64x60_wdt.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

Index: linux-2.6-powerpc-wdt/drivers/char/watchdog/mv64x60_wdt.c
===================================================================
--- linux-2.6-powerpc-wdt.orig/drivers/char/watchdog/mv64x60_wdt.c	2007-07-20 19:29:15.000000000 +0000
+++ linux-2.6-powerpc-wdt/drivers/char/watchdog/mv64x60_wdt.c	2007-07-20 19:29:34.000000000 +0000
@@ -132,6 +132,7 @@ static int mv64x60_wdt_ioctl(struct inod
 			     unsigned int cmd, unsigned long arg)
 {
 	int timeout;
+	int options;
 	void __user *argp = (void __user *)arg;
 	static struct watchdog_info info = {
 		.options =	WDIOF_SETTIMEOUT	|
@@ -157,7 +158,15 @@ static int mv64x60_wdt_ioctl(struct inod
 		return -EOPNOTSUPP;
 
 	case WDIOC_SETOPTIONS:
-		return -EOPNOTSUPP;
+		if (get_user(options, (int __user *)argp))
+			return -EFAULT;
+
+		if (options & WDIOS_DISABLECARD)
+			mv64x60_wdt_handler_disable();
+
+		if (options & WDIOS_ENABLECARD)
+			mv64x60_wdt_handler_enable();
+		break;
 
 	case WDIOC_KEEPALIVE:
 		mv64x60_wdt_service();

