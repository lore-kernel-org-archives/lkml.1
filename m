Return-Path: <linux-kernel-owner+w=401wt.eu-S1755431AbYJZRaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbYJZRaY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 13:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbYJZRaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 13:30:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:38747 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbYJZRaI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 13:30:08 -0400
Date: Sun, 26 Oct 2008 10:30:24 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: torvalds@linux-foundation.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, rjw@sisk.pl,
       rodriguez@atheros.com, johannes@sipsolutions.net
Subject: [PATCH] wireless: fix regression caused by regulatory config option
Message-ID: <20081026103024.2712ddc9@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9095a0f6005a8f50c79e51f4aaceda95e361a891 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sun, 26 Oct 2008 10:25:30 -0700
Subject: [PATCH] wireless: fix regression caused by regulatory config option

The default for the regulatory compatibility option is wrong;
if you picked the default you ended up with a non-functional wifi
system (at least I did on Fedora 9 with iwl4965).
I don't think even the October 2008 releases of the various distros
has the new userland so clearly the default is wrong, and also
we can't just go about deleting this in 2.6.29...

Change the default to "y" and also adjust the config text a little to
reflect this.

This patch fixes regression #11859

With thanks to Johannes Berg for the diagnostics

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 net/wireless/Kconfig |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index 7d82be0..646c712 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -16,7 +16,7 @@ config NL80211
 
 config WIRELESS_OLD_REGULATORY
 	bool "Old wireless static regulatory definitions"
-	default n
+	default y
 	---help---
 	  This option enables the old static regulatory information
 	  and uses it within the new framework. This is available
@@ -40,11 +40,10 @@ config WIRELESS_OLD_REGULATORY
 	  ieee80211_regdom module parameter. This is being phased out and you
 	  should stop using them ASAP.
 
-	  Say N unless you cannot install a new userspace application
-	  or have one currently depending on the ieee80211_regdom module
-	  parameter and cannot port it to use the new userspace interfaces.
-
-	  This is scheduled for removal for 2.6.29.
+	  Say Y unless you have installed a new userspace application.
+	  Also say Y if have one currently depending on the ieee80211_regdom
+	  module parameter and cannot port it to use the new userspace
+	  interfaces.
 
 config WIRELESS_EXT
 	bool "Wireless extensions"
-- 
1.5.6.5



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
