Return-Path: <linux-kernel-owner+w=401wt.eu-S1753041AbZEQPuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbZEQPuo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 11:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbZEQPuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 11:50:12 -0400
Received: from mx1.wp.pl ([212.77.101.5]:31439 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918AbZEQPuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 11:50:10 -0400
Date: Sun, 17 May 2009 17:56:17 +0200
From: Krzysztof Helt <krzysztof.h1@wp.pl>
To: linux-kbuild@vger.kernel.org
Cc: LKLM <linux-kernel@vger.kernel.org>
Subject: Kconfig: fix problem in HID menu
Message-Id: <20090517175617.81323cc1.krzysztof.h1@wp.pl>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [EYM0]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Helt <krzysztof.h1@wp.pl>

Following syntax does not work properly if there is an options FOO2 depending on the FOO:

config FOO
	tristate "Foo" if EMBEDDED
	depends on FUD
	default !EMBEDDED

config FOO2
	bool "Foo2"
	depends on FOO

If the EMBEDDED is not selected the FOO option is selected
and it cannot be unselected.

The change of the FOO definition:

config FOO
	tristate "Foo" 
	depends on EMBEDDED && FUD
	default !EMBEDDED

fixes the issue.

This is likely a bug in Kconfig tool.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
---

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 7e67dcb..c52204d 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -153,8 +153,8 @@ config HID_KENSINGTON
 	Support for Kensington Slimblade Trackball.
 
 config HID_LOGITECH
-	tristate "Logitech" if EMBEDDED
-	depends on USB_HID
+	tristate "Logitech"
+	depends on EMBEDDED && USB_HID
 	default !EMBEDDED
 	---help---
 	Support for Logitech devices that are not fully compliant with HID standard.
@@ -205,8 +205,8 @@ config HID_NTRIG
 	Support for N-Trig touch screen.
 
 config HID_PANTHERLORD
-	tristate "Pantherlord devices support" if EMBEDDED
-	depends on USB_HID
+	tristate "Pantherlord devices support"
+	depends on EMBEDDED && USB_HID
 	default !EMBEDDED
 	---help---
 	Support for PantherLord/GreenAsia based device support.
