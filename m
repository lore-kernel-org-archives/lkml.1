Return-Path: <linux-kernel-owner+w=401wt.eu-S1758540AbYEGOaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540AbYEGOaL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 10:30:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbYEGO3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 10:29:53 -0400
Received: from truxi.wincor-nixdorf.com ([217.115.67.78]:50647 "EHLO
	truxi.wincor-nixdorf.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbYEGO3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 10:29:50 -0400
X-Greylist: delayed 2039 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 May 2008 10:29:50 EDT
Message-ID: <4821B4BD.9010402@wincor-nixdorf.com>
Date: Wed, 07 May 2008 15:55:09 +0200
From: Niels de Vos <niels.devos@wincor-nixdorf.com>
Organization: Wincor Nixdorf International
User-Agent: Thunderbird 1.5.0.12 (X11/20080430)
MIME-Version: 1.0
To: sfr@canb.auug.org.au, linux-laptop@vger.kernel.org,
       linux-kernel@vger.kernel.org
CC: niels.devos@wincor-nixdorf.com
Subject: [PATCH] apm: make apm=power-off configurable like apm=realmode-power-off
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 May 2008 13:55:26.0586 (UTC) FILETIME=[00B305A0:01C8B04A]
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some systems (with broken BIOSes?) apm=power-off should be appended
as kernel parameter. apm=realmode-power-off is configurable during 
compile-time. apm=power-off should be configurable likewise.

On non-SMP systems apm=power-off is the default. For kernels with SMP
support it is not.

Signed-off-by: Niels de Vos <niels.devos@wincor-nixdorf.com>
--
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index bbcafaa..e051f38 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1457,6 +1457,16 @@ config APM_ALLOW_INTS
 	  many of the newer IBM Thinkpads.  If you experience hangs when you
 	  suspend, try setting this to Y.  Otherwise, say N.
 
+config APM_POWER_OFF
+	bool "Power off on shutdown"
+	depends on APM && SMP
+	help
+	  Force a power off on shutdown. Needed for some buggy BIOSes. If you
+	  run an SMP kernel on a non-SMP system with APM, you try turning on
+	  this option if your system does not power-off properly.
+
+	  Note: this option is equivalent to apm=power-off on the cmdline.
+
 config APM_REAL_MODE_POWER_OFF
 	bool "Use real mode APM BIOS call to power off"
 	help
diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index bf9290e..e3015da 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -385,7 +385,7 @@ static int bounce_interval __read_mostly = DEFAULT_BOUNCE_INTERVAL;
 static int debug __read_mostly;
 static int smp __read_mostly;
 static int apm_disabled = -1;
-#ifdef CONFIG_SMP
+#if defined(CONFIG_SMP) && !defined(CONFIG_APM_POWER_OFF)
 static int power_off;
 #else
 static int power_off = 1;

-- 
Wincor Nixdorf International GmbH
Sitz der Gesellschaft: Paderborn
Registergericht Paderborn HRB 3507
Geschäftsführer: Eckard Heidloff (Vorsitzender), Stefan Auerbach, Dr. Jürgen Wunram
Vorsitzender des Aufsichtsrats: Karl-Heinz Stiller
Steuernummer: 339/5884/0020 - Ust-ID Nr.: DE812927716 - WEEE-Reg.-Nr. DE44477193

Diese E-Mail enthält vertrauliche Informationen. Wenn Sie nicht der richtige Adressat sind oder diese E-Mail irrtümlich erhalten haben, informieren Sie bitte sofort den Absender und vernichten Sie diese E-Mail. Das unerlaubte Kopieren sowie die unbefugte Weitergabe dieser E-Mail ist nicht gestattet.

This e-mail may contain confidential information. If you are not the intended recipient (or have received this e-mail in error) please notify the sender immediately and destroy this e-mail. Any unauthorised copying, disclosure or distribution of the material in this e-mail is strictly forbidden.

