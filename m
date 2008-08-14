Return-Path: <linux-kernel-owner+w=401wt.eu-S1758246AbYHNGp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246AbYHNGp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 02:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755387AbYHNGig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 02:38:36 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:38162 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbYHNGiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 02:38:04 -0400
Date: Thu, 14 Aug 2008 00:14:38 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808140614.m7E6EcU5006265@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc3 27/29] mdb: export the clocksource nmi watchdog 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

export the clocksource nmi watchdog for the module based kernel debugger.
This function is called to prevent watchdog events while the debugger 
has processors in suspended states during active debugging sessions.


Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/kernel/time/clocksource.c	2008-08-13 14:22:32.000000000 -0600
+++ b/kernel/time/clocksource.c	2008-08-13 11:56:03.000000000 -0600
@@ -242,6 +242,9 @@
 {
 	clocksource_resume_watchdog();
 }
+#if defined(CONFIG_MDB_MODULE)
+EXPORT_SYMBOL_GPL(clocksource_touch_watchdog);
+#endif
 
 /**
  * clocksource_get_next - Returns the selected clocksource
