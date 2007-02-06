Return-Path: <linux-kernel-owner+w=401wt.eu-S1752664AbXBFDyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbXBFDyA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 22:54:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbXBFDx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 22:53:59 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:40396 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752664AbXBFDxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 22:53:32 -0500
Date: Mon, 5 Feb 2007 19:53:30 -0800
Message-Id: <200702060353.l163rUmj000771@zach-dev.vmware.com>
Subject: [PATCH 9/11] Panic delay fix
From: Zachary Amsden <zach@vmware.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>
X-OriginalArrivalTime: 06 Feb 2007 03:53:30.0629 (UTC) FILETIME=[5D8B5350:01C749A2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Failure to use real-time delay here causes the keyboard to become demonically
possessed in the event of a kernel crash, with wildly blinking lights and
unpredictable behavior.  This has resulted in several injuries.

Signed-off-by: Zachary Amsden <zach@vmware.com>

diff -r 10fac6d484e2 drivers/input/serio/i8042.c
--- a/drivers/input/serio/i8042.c	Tue Jan 30 16:44:54 2007 -0800
+++ b/drivers/input/serio/i8042.c	Tue Jan 30 16:45:00 2007 -0800
@@ -9,6 +9,7 @@
  * under the terms of the GNU General Public License version 2 as published by
  * the Free Software Foundation.
  */
+#define USE_REAL_TIME_DELAY
 
 #include <linux/delay.h>
 #include <linux/module.h>
