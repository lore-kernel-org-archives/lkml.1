Return-Path: <linux-kernel-owner+w=401wt.eu-S933219AbYD3U2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933219AbYD3U2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 16:28:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933099AbYD3U1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 16:27:25 -0400
Received: from mail.queued.net ([207.210.101.209]:4998 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933083AbYD3U1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 16:27:24 -0400
Date: Wed, 30 Apr 2008 16:30:30 -0400
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: cbou@mail.ru, linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: [PATCH 4/4] power_supply: bump EC version check that we refuse to
 run with in olpc_battery
Message-ID: <20080430163030.29e1ca9f@ephemeral>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Refuse to run with an EC < 0x44.  We're playing it safe, and this is
a pretty old EC version.

Also, add a comment about why we're checking the EC version.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/power/olpc_battery.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
index cb45a67..086b146 100644
--- a/drivers/power/olpc_battery.c
+++ b/drivers/power/olpc_battery.c
@@ -398,7 +398,12 @@ static int __init olpc_bat_init(void)
 
 	if (!olpc_platform_info.ecver)
 		return -ENXIO;
-	if (olpc_platform_info.ecver < 0x43) {
+
+	/*
+	 * We've seen a number of EC protocol changes; this driver requires
+	 * the latest EC protocol, supported by 0x44 and above.
+	 */
+	if (olpc_platform_info.ecver < 0x44) {
 		printk(KERN_NOTICE "OLPC EC version 0x%02x too old for battery driver.\n", olpc_platform_info.ecver);
 		return -ENXIO;
 	}
-- 
1.5.5

