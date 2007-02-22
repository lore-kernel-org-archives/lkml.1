Return-Path: <linux-kernel-owner+w=401wt.eu-S965137AbXBVEEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965137AbXBVEEs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 23:04:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965238AbXBVEEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 23:04:47 -0500
Received: from sycorax.lbl.gov ([128.3.11.121]:2583 "EHLO sycorax.lbl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965137AbXBVEEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 23:04:47 -0500
From: Alex Romosan <romosan@sycorax.lbl.gov>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Yaroslav Halchenko <kernel@onerussian.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net,
       James Simmons <jsimmons@infradead.org>
Subject: Re: no backlight on radeon after recent kernel "upgrade"s
References: <20070219044616.GC25659@washoe.onerussian.com>
	<20070219000412.acad13de.akpm@linux-foundation.org>
	<1171876788.6046.3.camel@localhost.localdomain>
	<877iub9mu2.fsf@sycorax.lbl.gov>
	<1172097718.5790.29.camel@localhost.localdomain>
Date: Wed, 21 Feb 2007 20:03:57 -0800
In-Reply-To: <1172097718.5790.29.camel@localhost.localdomain> (message from
	Richard Purdie on Wed, 21 Feb 2007 22:41:57 +0000)
Message-ID: <877iuaalea.fsf@sycorax.lbl.gov>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Purdie writes:

> Can you have a look at the differences between the defconfigs for
> 2.6.20 and 2.6.21-rc1?

this is probably the relevant part:

--- config-2.6.20	2007-02-04 12:09:28.000000000 -0800
+++ config-2.6.21-rc1	2007-02-21 08:37:53.000000000 -0800
@@ -1270,16 +1302,25 @@
 #
 # Graphics support
 #
-CONFIG_FIRMWARE_EDID=y
+CONFIG_BACKLIGHT_LCD_SUPPORT=y
+CONFIG_BACKLIGHT_CLASS_DEVICE=y
+CONFIG_LCD_CLASS_DEVICE=y
+# CONFIG_BACKLIGHT_PROGEAR is not set
 CONFIG_FB=y
+CONFIG_FIRMWARE_EDID=y
 CONFIG_FB_DDC=y
 CONFIG_FB_CFB_FILLRECT=y
 CONFIG_FB_CFB_COPYAREA=y
 CONFIG_FB_CFB_IMAGEBLIT=y
+# CONFIG_FB_SVGALIB is not set
 # CONFIG_FB_MACMODES is not set
-# CONFIG_FB_BACKLIGHT is not set
+CONFIG_FB_BACKLIGHT=y
 CONFIG_FB_MODE_HELPERS=y
 CONFIG_FB_TILEBLITTING=y
+
+#
+# Frambuffer hardware drivers
+#
 # CONFIG_FB_CIRRUS is not set
 # CONFIG_FB_PM2 is not set
 # CONFIG_FB_CYBER2000 is not set
@@ -1297,9 +1338,11 @@
 # CONFIG_FB_MATROX is not set
 CONFIG_FB_RADEON=y
 CONFIG_FB_RADEON_I2C=y
+CONFIG_FB_RADEON_BACKLIGHT=y
 # CONFIG_FB_RADEON_DEBUG is not set
 # CONFIG_FB_ATY128 is not set
 # CONFIG_FB_ATY is not set
+# CONFIG_FB_S3 is not set
 # CONFIG_FB_SAVAGE is not set
 # CONFIG_FB_SIS is not set
 # CONFIG_FB_NEOMAGIC is not set
@@ -1333,11 +1376,6 @@
 # CONFIG_LOGO_LINUX_MONO is not set
 # CONFIG_LOGO_LINUX_VGA16 is not set
 CONFIG_LOGO_LINUX_CLUT224=y
-CONFIG_BACKLIGHT_LCD_SUPPORT=y
-CONFIG_BACKLIGHT_CLASS_DEVICE=y
-CONFIG_BACKLIGHT_DEVICE=y
-CONFIG_LCD_CLASS_DEVICE=m
-CONFIG_LCD_DEVICE=y
 
 #
 # Sound


> If the backlight changes are at fault, I'm guessing James' Kconfig
> changes to the video Kconfig would be the culprit since
> FB_RADEON_BACKLIGHT only used to be selectable if PMAC_BACKLIGHT was
> enabled. On a thinkpad, the backlight is probably under ACPI
> control.

there was no FB_RADEON_BACKLIGHT in 2.6.20 and CONFIG_FB_BACKLIGHT
wasn't set.

> If FB_RADEON_BACKLIGHT wasn't set for 2.6.20, can you try 2.6.21-rc1
> with that option disabled?

i'll try recompiling without this option and let you know what happened.

> An ls /sys/class/backlight under 2.6.20 will tell us which driver it
> was using...

ls /sys/class/backlight/
0 ./  0 ../  0 ibm/

--alex--

-- 
| I believe the moment is at hand when, by a paranoiac and active |
|  advance of the mind, it will be possible (simultaneously with  |
|  automatism and other passive states) to systematize confusion  |
|  and thus to help to discredit completely the world of reality. |
