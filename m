Return-Path: <linux-kernel-owner+w=401wt.eu-S1756878AbXJJWUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878AbXJJWUJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 18:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbXJJWT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 18:19:58 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:60317
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755346AbXJJWT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 18:19:56 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: m68k Kconfig undefined symbol in 2.6.23.
Date: Wed, 10 Oct 2007 17:19:52 -0500
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710101719.52423.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The m68k Kconfig tries to select a symbol (APM_EMULATION) that doesn't exist.

I did this to fix it, without really understanding the larger problem.  (Did 
APM go away?)  Just FYI...

Rob

diff -r 79f0ea1e0e70 drivers/macintosh/Kconfig
--- a/drivers/macintosh/Kconfig	Tue Oct 09 21:00:40 2007 +0000
+++ b/drivers/macintosh/Kconfig	Wed Oct 10 17:17:07 2007 -0500
@@ -116,11 +116,6 @@ config PMAC_SMU
 	  on the "SMU" system control chip which replaces the old PMU.
 	  If you don't know, say Y.
 
-config PMAC_APM_EMU
-	tristate "APM emulation"
-	select APM_EMULATION
-	depends on ADB_PMU && PM && PPC32
-
 config PMAC_MEDIABAY
 	bool "Support PowerBook hotswap media bay"
 	depends on PPC_PMAC && PPC32

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
