Return-Path: <linux-kernel-owner+w=401wt.eu-S933193AbYEBKtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933193AbYEBKtw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 06:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759819AbYEBKtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 06:49:45 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:3742 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759596AbYEBKto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 06:49:44 -0400
Date: Fri, 2 May 2008 12:49:40 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] clocksource: Fix permissions for available_clocksource
Message-ID: <20080502104940.GA4426@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

File permissions for
/sys/devices/system/clocksource/clocksource0/available_clocksource
are 600 which allows write access. But this is in fact a read only
file. So change permissions to 400.

Cc: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 kernel/time/clocksource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/kernel/time/clocksource.c
===================================================================
--- linux-2.6.orig/kernel/time/clocksource.c
+++ linux-2.6/kernel/time/clocksource.c
@@ -474,7 +474,7 @@ sysfs_show_available_clocksources(struct
 static SYSDEV_ATTR(current_clocksource, 0600, sysfs_show_current_clocksources,
 		   sysfs_override_clocksource);
 
-static SYSDEV_ATTR(available_clocksource, 0600,
+static SYSDEV_ATTR(available_clocksource, 0400,
 		   sysfs_show_available_clocksources, NULL);
 
 static struct sysdev_class clocksource_sysclass = {
