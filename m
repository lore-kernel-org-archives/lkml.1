Return-Path: <linux-kernel-owner+w=401wt.eu-S1753841AbYKSO2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbYKSO2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 09:28:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbYKSO2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 09:28:04 -0500
Received: from ns0.wincor-nixdorf.com ([80.154.98.130]:50796 "EHLO
	mxpdbe2.wincor-nixdorf.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753235AbYKSO2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 09:28:01 -0500
X-Greylist: delayed 453 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Nov 2008 09:28:01 EST
Message-ID: <4924201B.8010301@wincor-nixdorf.com>
Date: Wed, 19 Nov 2008 15:18:03 +0100
From: Niels de Vos <niels.devos@wincor-nixdorf.com>
Organization: Wincor Nixdorf International
User-Agent: Thunderbird 2.0.0.17 (X11/20081001)
MIME-Version: 1.0
To: sfr@canb.auug.org.au, linux-laptop@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] apm: Remove CONFIG_APM_REAL_MODE_POWER_OFF in favor of kernel
 parameter
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Nov 2008 14:20:16.0690 (UTC) FILETIME=[F1D5D920:01C94A51]
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove CONFIG_APM_REAL_MODE_POWER_OFF like CONFIG_APM_POWER_OFF which
has been done for linux-2.2.14pre8 (http://lkml.org/lkml/1999/11/23/3).

Re-introducing CONFIG_APM_POWER_OFF got nack-ed. Stephen didn't bother
to remove CONFIG_APM_REAL_MODE_POWER_OFF, let's get rid of it now.
	Reference: http://lkml.org/lkml/2008/5/7/97

Signed-off-by: Niels de Vos <niels.devos@wincor-nixdorf.com>

---
 arch/x86/Kconfig         |    7 -------
 arch/x86/kernel/apm_32.c |    4 ----
 2 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 93224b5..d0b9ef7 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1629,13 +1629,6 @@ config APM_ALLOW_INTS
 	  many of the newer IBM Thinkpads.  If you experience hangs when you
 	  suspend, try setting this to Y.  Otherwise, say N.
 
-config APM_REAL_MODE_POWER_OFF
-	bool "Use real mode APM BIOS call to power off"
-	help
-	  Use real mode APM BIOS calls to switch off the computer. This is
-	  a work-around for a number of buggy BIOSes. Switch this option on if
-	  your computer crashes instead of powering off properly.
-
 endif # APM
 
 source "arch/x86/kernel/cpu/cpufreq/Kconfig"
diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index 5145a6e..3a26525 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -391,11 +391,7 @@ static int power_off;
 #else
 static int power_off = 1;
 #endif
-#ifdef CONFIG_APM_REAL_MODE_POWER_OFF
-static int realmode_power_off = 1;
-#else
 static int realmode_power_off;
-#endif
 #ifdef CONFIG_APM_ALLOW_INTS
 static int allow_ints = 1;
 #else


-- 
WINCOR NIXDORF International GmbH 
Sitz der Gesellschaft: Paderborn 
Registergericht Paderborn HRB 3507
Geschäftsführer: Eckard Heidloff (Vorsitzender), Stefan Auerbach, Dr. Jürgen Wunram
Vorsitzender des Aufsichtsrats: Karl-Heinz Stiller 
Steuernummer: 339/5884/0020 - Ust-ID Nr.: DE812927716 - WEEE-Reg.-Nr. DE44477193

Diese E-Mail enthält vertrauliche Informationen. Wenn Sie nicht der richtige Adressat sind oder diese E-Mail irrtümlich erhalten haben, informieren Sie bitte sofort den Absender und vernichten Sie diese E-Mail. Das unerlaubte Kopieren sowie die unbefugte Weitergabe dieser E-Mail ist nicht gestattet.

This e-mail may contain confidential information. If you are not the intended recipient (or have received this e-mail in error) please notify the sender immediately and destroy this e-mail. Any unauthorised copying, disclosure or distribution of the material in this e-mail is strictly forbidden. 

