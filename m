Return-Path: <linux-kernel-owner+w=401wt.eu-S1753325AbYKGWP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbYKGWP7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 17:15:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbYKGWPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 17:15:17 -0500
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:23965 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751607AbYKGWPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 17:15:13 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=LW1ymJVkoB5D0nhkgEBu9/wepe5AorPoflP8BALzTbOt1TcKsayyMwfpQwcUoD0UlcnNTptoigAwm6Q4F+Mwntp6l8Ezp3sZBRbVobZD6t2eTMqc9dcwo9jJuDNm1d/5tyLLRwjfpKh0aKBc8keNgz/OZ2oXCppnf5jPUQacYss=  ;
X-YMail-OSG: yCgGvDIVM1mLpchhV_Os60ul9pESo1iCn4HECUUa9Rj1ut5F04aJbFrfCLedeyUR.nnBGFTuyTjeOsxZqXRstdQ2tUwDjrrW08l8p0vt78jl69jQZClWI4dp0IJQJmncaxVOBIuTFX_yAxRxlw4VBj78
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com
Subject: [patch 2.6.28-rc3-git] regulator: Kconfig works normally
Date: Fri, 7 Nov 2008 14:03:54 -0800
User-Agent: KMail/1.9.10
Cc: lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200811071403.54469.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: David Brownell <dbrownell@users.sourceforge.net>

Fix dependencies in drivers/regulator/Kconfig:  don't show *ANY*
options unless regulator support is enabled.  Also get rid of all
the nasty reverse dependencies.  This just switches over to use
standard Kconfig idioms, making this tree act normally.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/regulator/Kconfig |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -23,21 +23,20 @@ config REGULATOR
 
 	  If unsure, say no.
 
+if REGULATOR
+
 config REGULATOR_DEBUG
 	bool "Regulator debug support"
-	depends on REGULATOR
 	help
 	  Say yes here to enable debugging support.
 
 config REGULATOR_FIXED_VOLTAGE
 	tristate
 	default n
-	select REGULATOR
 
 config REGULATOR_VIRTUAL_CONSUMER
 	tristate "Virtual regulator consumer support"
 	default n
-	select REGULATOR
 	help
 	  This driver provides a virtual consumer for the voltage and
           current regulator API which provides sysfs controls for
@@ -49,7 +48,6 @@ config REGULATOR_VIRTUAL_CONSUMER
 config REGULATOR_BQ24022
 	tristate "TI bq24022 Dual Input 1-Cell Li-Ion Charger IC"
 	default n
-	select REGULATOR
 	help
 	  This driver controls a TI bq24022 Charger attached via
 	  GPIOs. The provided current regulator can enable/disable
@@ -59,7 +57,6 @@ config REGULATOR_BQ24022
 config REGULATOR_WM8350
 	tristate "Wolfson Microelectroncis WM8350 AudioPlus PMIC"
 	depends on MFD_WM8350
-	select REGULATOR
 	help
 	  This driver provides support for the voltage and current regulators
           of the WM8350 AudioPlus PMIC.
@@ -67,7 +64,6 @@ config REGULATOR_WM8350
 config REGULATOR_WM8400
 	tristate "Wolfson Microelectroncis WM8400 AudioPlus PMIC"
 	depends on MFD_WM8400
-	select REGULATOR
 	help
 	  This driver provides support for the voltage regulators of the
 	  WM8400 AudioPlus PMIC.
@@ -75,9 +71,10 @@ config REGULATOR_WM8400
 config REGULATOR_DA903X
 	tristate "Support regulators on Dialog Semiconductor DA9030/DA9034 PMIC"
 	depends on PMIC_DA903X
-	select REGULATOR
 	help
 	  Say y here to support the BUCKs and LDOs regulators found on
 	  Dialog Semiconductor DA9030/DA9034 PMIC.
 
+endif
+
 endmenu
