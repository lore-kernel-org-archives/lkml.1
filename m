Return-Path: <linux-kernel-owner+w=401wt.eu-S1754003AbYEQK2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbYEQK2g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 06:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbYEQK21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 06:28:27 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:55746 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbYEQK20 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 06:28:26 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, rpurdie@rpsys.net
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.26-rc2-mm1 and Linus -git: LEDS_TRIGGER_DEFAULT_ON odd default
In-Reply-To: Your message of "Wed, 14 May 2008 01:01:29 PDT."
             <20080514010129.4f672378.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20080514010129.4f672378.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1211020093_14984P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 17 May 2008 06:28:13 -0400
Message-ID: <46746.1211020093@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1211020093_14984P
Content-Type: text/plain; charset=us-ascii

On Wed, 14 May 2008 01:01:29 PDT, Andrew Morton said:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.26-rc2/2.6.26-rc2-mm1/

Seen in a 'make silentoldconfig':

---
    LED Default ON Trigger (LEDS_TRIGGER_DEFAULT_ON) [N/m/y/?] (NEW) ?

This allows LEDs to be initialised in the ON state.
If unsure, say Y.
---

The default is N, but if unsure, say Y.  Some digging shows that it's because
there's a "depends on LEDS_TRIGGERS" that I had set to N.  I wonder if the
various 'config LEDS_TRIGGER_FOO' in drivers/leds/Kconfig should all be
wrapped in one 'if LEDS_TRIGGERS'?  Kind of like this totally untested patch:

If I'm actually right here, here's a:

Signed-Off-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>

--- linux-2.6.26-rc2-mm1/drivers/leds/Kconfig.before	2008-05-17 06:22:03.000000000 -0400
+++ linux-2.6.26-rc2-mm1/drivers/leds/Kconfig	2008-05-17 06:22:55.000000000 -0400
@@ -164,9 +164,9 @@ config LEDS_TRIGGERS
 	  These triggers allow kernel events to drive the LEDs and can
 	  be configured via sysfs. If unsure, say Y.
 
+if LEDS_TRIGGERS
 config LEDS_TRIGGER_TIMER
 	tristate "LED Timer Trigger"
-	depends on LEDS_TRIGGERS
 	help
 	  This allows LEDs to be controlled by a programmable timer
 	  via sysfs. Some LED hardware can be programmed to start
@@ -177,14 +177,13 @@ config LEDS_TRIGGER_TIMER
 
 config LEDS_TRIGGER_IDE_DISK
 	bool "LED IDE Disk Trigger"
-	depends on LEDS_TRIGGERS && BLK_DEV_IDEDISK
+	depends on BLK_DEV_IDEDISK
 	help
 	  This allows LEDs to be controlled by IDE disk activity.
 	  If unsure, say Y.
 
 config LEDS_TRIGGER_HEARTBEAT
 	tristate "LED Heartbeat Trigger"
-	depends on LEDS_TRIGGERS
 	help
 	  This allows LEDs to be controlled by a CPU load average.
 	  The flash frequency is a hyperbolic function of the 1-minute
@@ -193,9 +192,9 @@ config LEDS_TRIGGER_HEARTBEAT
 
 config LEDS_TRIGGER_DEFAULT_ON
 	tristate "LED Default ON Trigger"
-	depends on LEDS_TRIGGERS
 	help
 	  This allows LEDs to be initialised in the ON state.
 	  If unsure, say Y.
 
+endif # LEDS_TRIGGERS
 endif # NEW_LEDS



--==_Exmh_1211020093_14984P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFILrM9cC3lWbTT17ARAmxkAJ4gCW0lUEoGGxMY6jWr0r4gVVn4vQCcCSFZ
xslUF5tk+n5lTUhLBFYtdKw=
=FkeO
-----END PGP SIGNATURE-----

--==_Exmh_1211020093_14984P--
