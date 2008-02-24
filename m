Return-Path: <linux-kernel-owner+w=401wt.eu-S1755881AbYBXDpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881AbYBXDpj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 22:45:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751624AbYBXDpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 22:45:33 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:42809 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbYBXDpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 22:45:32 -0500
Date: Sun, 24 Feb 2008 05:44:40 +0200
From: Adrian Bunk <bunk@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6.25 patch] fix drivers/usb/host/u132-hcd.c compilation
Message-ID: <20080224034440.GA1596@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following compile error caused by
commit 3a2d5b700132f35401f1d9e22fe3c2cab02c2549:

<--  snip  -->

...
  CC      drivers/usb/host/u132-hcd.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/usb/host/u132-hcd.c: 
In function ‘u132_suspend’:
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/usb/host/u132-hcd.c:3224: error: expected expression before ‘int’
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/usb/host/u132-hcd.c:3225: error: ‘ports’ undeclared (first use in this function)
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/usb/host/u132-hcd.c:3225: error: (Each undeclared identifier is reported only once
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/usb/host/u132-hcd.c:3225: error: for each function it appears in.)
make[4]: *** [drivers/usb/host/u132-hcd.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
69cf78da6371ad2aca30844858eeea318b37b3ec diff --git a/drivers/usb/host/u132-hcd.c b/drivers/usb/host/u132-hcd.c
index 6fca069..325c6c7 100644
--- a/drivers/usb/host/u132-hcd.c
+++ b/drivers/usb/host/u132-hcd.c
@@ -3221,9 +3221,11 @@ static int u132_suspend(struct platform_device *pdev, pm_message_t state)
 			break;
 		case PM_EVENT_SUSPEND:
 		case PM_EVENT_HIBERNATE:
-                        int ports = MAX_U132_PORTS;
-                        while (ports-- > 0) {
-                                port_power(u132, ports, 0);
+			{
+				int ports = MAX_U132_PORTS;
+				while (ports-- > 0) {
+					port_power(u132, ports, 0);
+				}
                         }
 			break;
 		}
