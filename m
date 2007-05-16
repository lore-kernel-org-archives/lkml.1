Return-Path: <linux-kernel-owner+w=401wt.eu-S1761420AbXEPA1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761420AbXEPA1c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 20:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758999AbXEPA1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 20:27:25 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:40316 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758793AbXEPA1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 20:27:24 -0400
Date: Tue, 15 May 2007 17:27:20 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: ak@suse.de, akpm@linux-foundation.org, dipankar@in.ibm.com,
       randy.dunlap@oracle.com
Subject: [PATCH] prohibit rcutorture from being compiled into the kernel
Message-ID: <20070516002720.GA22379@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

There have been a number of instances where people have accidentally
compiled rcutorture into the kernel (CONFIG_RCU_TORTURE_TEST=y), which
has never been useful, and has often resulted in great frustration.  The
attached patch prohibits rcutorture from being compiled into the kernel.
It may be excluded altogether or compiled as a module.  People wishing
to have rcutorture hammer their machine immediately upon boot are free
to hand-edit lib/Kconfig.debug to remove the "depends on m" line.

Thanks to Randy Dunlap for the trick that makes this work.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 Kconfig.debug |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -urpNa -X dontdiff linux-2.6.21/lib/Kconfig.debug linux-2.6.21-rcutorturemodonly/lib/Kconfig.debug
--- linux-2.6.21/lib/Kconfig.debug	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.21-rcutorturemodonly/lib/Kconfig.debug	2007-05-15 17:17:14.000000000 -0700
@@ -382,14 +382,13 @@ config FORCED_INLINING
 config RCU_TORTURE_TEST
 	tristate "torture tests for RCU"
 	depends on DEBUG_KERNEL
+	depends on m
 	default n
 	help
 	  This option provides a kernel module that runs torture tests
 	  on the RCU infrastructure.  The kernel module may be built
 	  after the fact on the running kernel to be tested, if desired.
 
-	  Say Y here if you want RCU torture tests to start automatically
-	  at boot time (you probably don't).
 	  Say M if you want the RCU torture tests to build as a module.
 	  Say N if you are unsure.
 
