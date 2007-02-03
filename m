Return-Path: <linux-kernel-owner+w=401wt.eu-S1946237AbXBCCfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946237AbXBCCfq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:35:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946236AbXBCCfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:35:45 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52651 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946238AbXBCCfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:35:44 -0500
Message-Id: <20070203023814.981415000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:08 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Andrew Morton <akpm@osdl.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Michael Buesch <mb@bu3sch.de>, Linus Torvalds <torvalds@osdl.org>,
       dsaxena@plexity.net, jgarzik@redhat.com, info-linux@geode.amd.com
Subject: [patch 04/59] Fix HWRNG built-in initcalls priority
Content-Disposition: inline; filename=fix-hwrng-built-in-initcalls-priority.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Michael Buesch <mb@bu3sch.de>

This changes all HWRNG driver initcalls to module_init().
We must probe the RNGs after the major kernel subsystems
are already up and running (like PCI).
This fixes Bug 7730.
http://bugzilla.kernel.org/show_bug.cgi?id=7730

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/char/hw_random/amd-rng.c    |    2 +-
 drivers/char/hw_random/geode-rng.c  |    2 +-
 drivers/char/hw_random/intel-rng.c  |    2 +-
 drivers/char/hw_random/ixp4xx-rng.c |    2 +-
 drivers/char/hw_random/via-rng.c    |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

--- linux-2.6.19.2.orig/drivers/char/hw_random/amd-rng.c
+++ linux-2.6.19.2/drivers/char/hw_random/amd-rng.c
@@ -144,7 +144,7 @@ static void __exit mod_exit(void)
 	hwrng_unregister(&amd_rng);
 }
 
-subsys_initcall(mod_init);
+module_init(mod_init);
 module_exit(mod_exit);
 
 MODULE_AUTHOR("The Linux Kernel team");
--- linux-2.6.19.2.orig/drivers/char/hw_random/geode-rng.c
+++ linux-2.6.19.2/drivers/char/hw_random/geode-rng.c
@@ -125,7 +125,7 @@ static void __exit mod_exit(void)
 	iounmap(mem);
 }
 
-subsys_initcall(mod_init);
+module_init(mod_init);
 module_exit(mod_exit);
 
 MODULE_DESCRIPTION("H/W RNG driver for AMD Geode LX CPUs");
--- linux-2.6.19.2.orig/drivers/char/hw_random/intel-rng.c
+++ linux-2.6.19.2/drivers/char/hw_random/intel-rng.c
@@ -350,7 +350,7 @@ static void __exit mod_exit(void)
 	iounmap(mem);
 }
 
-subsys_initcall(mod_init);
+module_init(mod_init);
 module_exit(mod_exit);
 
 MODULE_DESCRIPTION("H/W RNG driver for Intel chipsets");
--- linux-2.6.19.2.orig/drivers/char/hw_random/ixp4xx-rng.c
+++ linux-2.6.19.2/drivers/char/hw_random/ixp4xx-rng.c
@@ -64,7 +64,7 @@ static void __exit ixp4xx_rng_exit(void)
 	iounmap(rng_base);
 }
 
-subsys_initcall(ixp4xx_rng_init);
+module_init(ixp4xx_rng_init);
 module_exit(ixp4xx_rng_exit);
 
 MODULE_AUTHOR("Deepak Saxena <dsaxena@plexity.net>");
--- linux-2.6.19.2.orig/drivers/char/hw_random/via-rng.c
+++ linux-2.6.19.2/drivers/char/hw_random/via-rng.c
@@ -176,7 +176,7 @@ static void __exit mod_exit(void)
 	hwrng_unregister(&via_rng);
 }
 
-subsys_initcall(mod_init);
+module_init(mod_init);
 module_exit(mod_exit);
 
 MODULE_DESCRIPTION("H/W RNG driver for VIA chipsets");

--
