Return-Path: <linux-kernel-owner+w=401wt.eu-S1756456AbXJBVNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456AbXJBVNG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 17:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755157AbXJBVMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 17:12:55 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:63764 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990AbXJBVMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 17:12:54 -0400
Date: Tue, 2 Oct 2007 14:12:25 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>, dmitry.torokhov@gmail.com
Cc: linux-input@atrey.karlin.mff.cuni.cz, akpm <akpm@linux-foundation.org>
Subject: [PATCH] input: move gameports out of SERIO menu
Message-Id: <20071002141225.d503cdbb.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Move the gameport support menu out of the SERIO menu and put it
between touchscreens and misc. devices in the main input layer menu.
Change it to use menuconfig instead of config.

Or was it meant to be listed under Hardware I/O ports?
It sure seems odd there to me.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/input/Kconfig          |    4 ++--
 drivers/input/gameport/Kconfig |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6.23-rc8-mm1.orig/drivers/input/Kconfig
+++ linux-2.6.23-rc8-mm1/drivers/input/Kconfig
@@ -171,6 +171,8 @@ source "drivers/input/tablet/Kconfig"
 
 source "drivers/input/touchscreen/Kconfig"
 
+source "drivers/input/gameport/Kconfig"
+
 source "drivers/input/misc/Kconfig"
 
 endif
@@ -179,8 +181,6 @@ menu "Hardware I/O ports"
 
 source "drivers/input/serio/Kconfig"
 
-source "drivers/input/gameport/Kconfig"
-
 endmenu
 
 endmenu
--- linux-2.6.23-rc8-mm1.orig/drivers/input/gameport/Kconfig
+++ linux-2.6.23-rc8-mm1/drivers/input/gameport/Kconfig
@@ -1,8 +1,8 @@
 #
 # Gameport configuration
 #
-config GAMEPORT
-	tristate "Gameport support"
+menuconfig GAMEPORT
+	bool "Gameport support"
 	---help---
 	  Gameport support is for the standard 15-pin PC gameport. If you
 	  have a joystick, gamepad, gameport card, a soundcard with a gameport
