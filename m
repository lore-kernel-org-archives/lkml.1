Return-Path: <linux-kernel-owner+w=401wt.eu-S1755952AbYFFMyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbYFFMyB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 08:54:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753300AbYFFMxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 08:53:50 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:32184 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751498AbYFFMxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 08:53:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=OHjmNOzcWlvBoVEtv1AIHns84qeMvk3Kut2xKcGqGehRC7O2O7UhEqIS/CEvOPgt65xVcIrzrg1d+u4WETEsjcZb5wLnQmIWLEpPAf/tb/MJb6WY2zFicBxNTiDNhA+du//4dew7bBKP0MEBfl+ktwS6cF7sBCLpxk2zVHw8hOM=  ;
X-YMail-OSG: Pex4baMVM1lNSXhkxFXTZKmC_x0bIELT5SGPOLv0iX3uycCYApeXh5RRy3cj9kfSL9TpHmOe3Ea_MsP.HxssAANgBRIsY1xpOxTZGhP832gtd5WDxi3izOnHqljGlj7nmWY-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2.6.26-rc5] make HPET_RTC_IRQ track HPET_EMULATE_RTC
Date: Thu, 5 Jun 2008 22:41:44 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806052241.44713.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

More Kconfig tweaks related to the legacy PC RTC code:

 - Describe the legacy PC RTC driver as such ... it's never quite
   been clear that this driver is for PC RTCs, and now it's fair
   to call this the "legacy" driver.

 - Force it to understand about HPET stealing its IRQs ... kernel
   code does this always when HPET is in use, there should be no
   option for users to goof up the config.

This seems to fix kernel bugzilla #10729.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/char/Kconfig |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/char/Kconfig	2008-05-24 11:57:49.000000000 -0700
+++ b/drivers/char/Kconfig	2008-05-24 12:08:55.000000000 -0700
@@ -749,7 +749,7 @@ config NVRAM
 if RTC_LIB=n
 
 config RTC
-	tristate "Enhanced Real Time Clock Support"
+	tristate "Enhanced Real Time Clock Support (legacy PC RTC driver)"
 	depends on !PPC && !PARISC && !IA64 && !M68K && !SPARC && !FRV \
 			&& !ARM && !SUPERH && !S390 && !AVR32
 	---help---
@@ -1036,9 +1036,9 @@ config HPET
 	  non-periodic and/or periodic.
 
 config HPET_RTC_IRQ
-	bool "HPET Control RTC IRQ" if !HPET_EMULATE_RTC
-	default n
-	depends on HPET
+	bool
+	default HPET_EMULATE_RTC
+	depends on RTC && HPET
 	help
 	  If you say Y here, you will disable RTC_IRQ in drivers/char/rtc.c. It
 	  is assumed the platform called hpet_alloc with the RTC IRQ values for
