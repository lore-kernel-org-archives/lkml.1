Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892Ab0BXTpW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 14:45:22 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:45011 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757736Ab0BXTpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 14:45:21 -0500
Date: Wed, 24 Feb 2010 11:39:20 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org
Subject: [PATCH -next] staging: rtl8192* needs semaphore.h
Message-Id: <20100224113920.b1ac13af.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4B858097.00FA:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

The rtl8192* drivers in staging use semaphores, so they need
to #include <linux/semaphore.h>.

(similar to staging-rtl8187se-needs-semaphore.h.patch)

drivers/staging/rtl8192e/ieee80211/ieee80211.h:2038: error: field 'ips_sem' has incomplete type
drivers/staging/rtl8192e/ieee80211/ieee80211.h:2249: error: field 'wx_sem' has incomplete type
drivers/staging/rtl8192e/ieee80211/ieee80211.h:2250: error: field 'scan_sem' has incomplete type
drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c:442: error: implicit declaration of function 'down'
drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c:500: error: implicit declaration of function 'up'
drivers/staging/rtl8192e/ieee80 211/ieee80211_softmac.c:3165: error: implicit declaration of function 'sema_init'

drivers/staging/rtl8192su/ieee80211/ieee80211.h:1330: error: field 'wx_sem' has incomplete type
drivers/staging/rtl8192su/ieee80211/ieee80211.h:1331: error: field 'scan_sem' has incomplete type

drivers/staging/rtl8192u/ieee80211/ieee80211.h:2010: error: field 'wx_sem' has incomplete type
drivers/staging/rtl8192u/ieee80211/ieee80211.h:2011: error: field 'scan_sem' has incomplete type

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/rtl8192e/ieee80211/ieee80211.h  |    1 +
 drivers/staging/rtl8192su/ieee80211/ieee80211.h |    1 +
 drivers/staging/rtl8192u/ieee80211/ieee80211.h  |    1 +
 3 files changed, 3 insertions(+)

--- linux-next-20100224.orig/drivers/staging/rtl8192e/ieee80211/ieee80211.h
+++ linux-next-20100224/drivers/staging/rtl8192e/ieee80211/ieee80211.h
@@ -35,6 +35,7 @@
 #endif
 #include <linux/timer.h>
 #include <linux/sched.h>
+#include <linux/semaphore.h>
 
 #include <linux/delay.h>
 #include <linux/wireless.h>
--- linux-next-20100224.orig/drivers/staging/rtl8192u/ieee80211/ieee80211.h
+++ linux-next-20100224/drivers/staging/rtl8192u/ieee80211/ieee80211.h
@@ -30,6 +30,7 @@
 #include <linux/jiffies.h>
 #include <linux/timer.h>
 #include <linux/sched.h>
+#include <linux/semaphore.h>
 
 #include <linux/delay.h>
 #include <linux/wireless.h>
--- linux-next-20100224.orig/drivers/staging/rtl8192su/ieee80211/ieee80211.h
+++ linux-next-20100224/drivers/staging/rtl8192su/ieee80211/ieee80211.h
@@ -30,6 +30,7 @@
 #include <linux/jiffies.h>
 #include <linux/timer.h>
 #include <linux/sched.h>
+#include <linux/semaphore.h>
 
 #include <linux/delay.h>
 #include <linux/wireless.h>
