Return-Path: <linux-kernel-owner+w=401wt.eu-S1753639AbYE2IDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639AbYE2IDO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 04:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbYE2ICz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 04:02:55 -0400
Received: from gw.goop.org ([64.81.55.164]:50542 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbYE2ICy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 04:02:54 -0400
Message-ID: <483E630B.5090006@goop.org>
Date: Thu, 29 May 2008 09:02:19 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] xen: fix compilation when CONFIG_PM_SLEEP is disabled
References: <patchbomb.1211550067@localhost> <9e8d06e5ae8024829836.1211550077@localhost> <20080529073150.GA19744@elte.hu>
In-Reply-To: <20080529073150.GA19744@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xen save/restore depends on CONFIG_PM_SLEEP being set for device_power_up/down.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>

---
 drivers/xen/manage.c |    2 ++
 1 file changed, 2 insertions(+)

===================================================================
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -31,6 +31,7 @@
 /* Ignore multiple shutdown requests. */
 static enum shutdown_state shutting_down = SHUTDOWN_INVALID;
 
+#ifdef CONFIG_PM_SLEEP
 static int xen_suspend(void *data)
 {
 	int *cancelled = data;
@@ -121,6 +122,7 @@
 #endif
 	shutting_down = SHUTDOWN_INVALID;
 }
+#endif	/* CONFIG_PM_SLEEP */
 
 static void shutdown_handler(struct xenbus_watch *watch,
 			     const char **vec, unsigned int len)


