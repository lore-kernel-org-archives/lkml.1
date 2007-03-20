Return-Path: <linux-kernel-owner+w=401wt.eu-S934073AbXCTU3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934073AbXCTU3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 16:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934076AbXCTU3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 16:29:25 -0400
Received: from smtp112.sbc.mail.re2.yahoo.com ([68.142.229.93]:21572 "HELO
	smtp112.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934073AbXCTU3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 16:29:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=2WXKenWn8Znh0PgJubtVYbpebDec9mKYC191mmEtkCmfpv3EbVc8Yk35ku+vzqxATO1CX3gW0tk9Ya7voJx+YqBQyyJkdgM5N9YL4H4nBdNqm90uIyzUAq7ThIUw1W7fpg2UGRhHNzd4vJlAFKjXAkl+QoWaHKih8b1SfOTEWuM=  ;
X-YMail-OSG: TMWXcHkVM1lCjYbN9Smoeb6rDWauyg_zS8HREniBpgRuDWp1jUf4eQyurvNtCiu.25c9RnWNjh0f8LbDFX4n8YYJydGeP1jTUyanPSYGxbpgm9ZMQRWABXL16pdN0inkctSrppVRogO3rw--
From: David Brownell <david-b@pacbell.net>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.21-rc4-git] fix SND_SOC Kconfig
Date: Tue, 20 Mar 2007 13:49:51 -0700
User-Agent: KMail/1.7.1
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703201349.52156.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The new ALSA "SOC" support has bogus Kconfig ... it should
not be presenting anything AT91-related except on AT91,
or anything PXA-related except on PXA.  Right now, x86
sees both of those menus, as do all other platforms.

This patch removes needless Kconfig layering, and the
related inappropriate choice presentation.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

Index: g26/sound/soc/Kconfig
===================================================================
--- g26.orig/sound/soc/Kconfig	2007-03-18 14:11:36.000000000 -0700
+++ g26/sound/soc/Kconfig	2007-03-20 13:33:06.000000000 -0700
@@ -22,11 +22,8 @@ config SND_SOC
 	  will be called snd-soc-core.
 
 # All the supported Soc's
-menu "SoC Platforms"
-depends on SND_SOC
 source "sound/soc/at91/Kconfig"
 source "sound/soc/pxa/Kconfig"
-endmenu
 
 # Supported codecs
 source "sound/soc/codecs/Kconfig"
Index: g26/sound/soc/at91/Kconfig
===================================================================
--- g26.orig/sound/soc/at91/Kconfig	2007-03-18 14:11:36.000000000 -0700
+++ g26/sound/soc/at91/Kconfig	2007-03-20 13:31:52.000000000 -0700
@@ -1,5 +1,3 @@
-menu "SoC Audio for the Atmel AT91"
-
 config SND_AT91_SOC
 	tristate "SoC Audio for the Atmel AT91 System-on-Chip"
 	depends on ARCH_AT91 && SND_SOC
@@ -27,5 +25,3 @@ config SND_AT91_SOC_ETI_SLAVE
 	help
 	  Say Y if you want to run with the AT91 SSC generating the BCLK
 	  and LRC signals on Endrelia boards.
-
-endmenu
Index: g26/sound/soc/pxa/Kconfig
===================================================================
--- g26.orig/sound/soc/pxa/Kconfig	2007-03-18 14:11:36.000000000 -0700
+++ g26/sound/soc/pxa/Kconfig	2007-03-20 13:31:57.000000000 -0700
@@ -1,5 +1,3 @@
-menu "SoC Audio for the Intel PXA2xx"
-
 config SND_PXA2XX_SOC
 	tristate "SoC Audio for the Intel PXA2xx chip"
 	depends on ARCH_PXA && SND_SOC
@@ -55,5 +53,3 @@ config SND_PXA2XX_SOC_TOSA
 	help
 	  Say Y if you want to add support for SoC audio on Sharp
 	  Zaurus SL-C6000x models (Tosa).
-
-endmenu
