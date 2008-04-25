Return-Path: <linux-kernel-owner+w=401wt.eu-S1758804AbYDYGfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804AbYDYGfb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 02:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756509AbYDYGfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 02:35:22 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54283
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755934AbYDYGfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 02:35:22 -0400
Date: Thu, 24 Apr 2008 23:35:21 -0700 (PDT)
Message-Id: <20080424.233521.111619900.davem@davemloft.net>
To: plamen.petrov@fs.ru.acad.bg
Cc: ivdoorn@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: latest git (linux-2.6.25-git6) compile error
From: David Miller <davem@davemloft.net>
In-Reply-To: <481173E7.3050903@fs.ru.acad.bg>
References: <200804250028.24913.pvp@fs.ru.acad.bg>
	<200804250107.40778.IvDoorn@gmail.com>
	<481173E7.3050903@fs.ru.acad.bg>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Plamen Petrov <plamen.petrov@fs.ru.acad.bg>
Date: Fri, 25 Apr 2008 09:02:15 +0300

> Ivo van Doorn wrote:
> > Can you confirm that this error goes away when enabling CONFIG_NEW_LEDS ?
> >
> > Ivo
> >   
> Will try and report later - now I'm at work, away from the machine.

This should have been fixed by the patch below.

Or is it the problem that simply selecting LEDS_CLASS doesn't take
care of LEDS_CLASS's dependencies such as NEW_LEDS?  Ugh, if so...

commit 201410ce85d80b7b893cdc72e944a1341dd393f1
Author: David S. Miller <davem@davemloft.net>
Date:   Wed Apr 23 03:34:50 2008 -0700

    rt2x00: Select LEDS_CLASS.
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index a1e3938..ab1029e 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -60,7 +60,8 @@ config RT2400PCI_RFKILL
 
 config RT2400PCI_LEDS
 	bool "RT2400 leds support"
-	depends on RT2400PCI && LEDS_CLASS
+	depends on RT2400PCI
+	select LEDS_CLASS
 	select RT2X00_LIB_LEDS
 	---help---
 	  This adds support for led triggers provided my mac80211.
@@ -86,7 +87,8 @@ config RT2500PCI_RFKILL
 
 config RT2500PCI_LEDS
 	bool "RT2500 leds support"
-	depends on RT2500PCI && LEDS_CLASS
+	depends on RT2500PCI
+	select LEDS_CLASS
 	select RT2X00_LIB_LEDS
 	---help---
 	  This adds support for led triggers provided my mac80211.
@@ -114,7 +116,8 @@ config RT61PCI_RFKILL
 
 config RT61PCI_LEDS
 	bool "RT61 leds support"
-	depends on RT61PCI && LEDS_CLASS
+	depends on RT61PCI
+	select LEDS_CLASS
 	select RT2X00_LIB_LEDS
 	---help---
 	  This adds support for led triggers provided my mac80211.
@@ -130,7 +133,8 @@ config RT2500USB
 
 config RT2500USB_LEDS
 	bool "RT2500 leds support"
-	depends on RT2500USB && LEDS_CLASS
+	depends on RT2500USB
+	select LEDS_CLASS
 	select RT2X00_LIB_LEDS
 	---help---
 	  This adds support for led triggers provided my mac80211.
@@ -148,7 +152,8 @@ config RT73USB
 
 config RT73USB_LEDS
 	bool "RT73 leds support"
-	depends on RT73USB && LEDS_CLASS
+	depends on RT73USB
+	select LEDS_CLASS
 	select RT2X00_LIB_LEDS
 	---help---
 	  This adds support for led triggers provided my mac80211.
