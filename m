Return-Path: <linux-kernel-owner+w=401wt.eu-S1761882AbZDQQg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761882AbZDQQg6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 12:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757406AbZDQQgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 12:36:48 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:12872 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759210AbZDQQgr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 12:36:47 -0400
X-BigFish: VPS0(zzzz1202hzzz2fh6bh14bh62h)
X-Spam-TCS-SCL: 1:0
Message-ID: <49E8B015.7060808@am.sony.com>
Date: Fri, 17 Apr 2009 09:36:37 -0700
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: subrata@linux.vnet.ibm.com, Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
       sachinp <sachinp@linux.vnet.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next <linux-next@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Olof Johansson <olof@lixom.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [patch] powerpc/pasemi: Fix no SMP build error
References: <1239285094.5188.65.camel@subratamodak.linux.ibm.com>
In-Reply-To: <1239285094.5188.65.camel@subratamodak.linux.ibm.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset="UTF-8"
X-OriginalArrivalTime: 17 Apr 2009 16:36:38.0623 (UTC) FILETIME=[AE327EF0:01C9BF7A]
X-SEL-encryption-scan: scanned
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A non-SMP version of smp_send_stop() is now included in smp.h.
Remove the unneeded def in the pasemi setup.c.

Fixes build errors like these when CONFIG_SMP=n:

  arch/powerpc/platforms/pasemi/setup.c:48: error: redefinition of ‘smp_send_stop’
  include/linux/smp.h:125: error: previous definition of 'smp_send_stop' was here

Reported-by: subrata@linux.vnet.ibm.com
Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
---

diff --git a/arch/powerpc/platforms/pasemi/setup.c b/arch/powerpc/platforms/pasemi/setup.c
index c64fb5b..153051e 100644
--- a/arch/powerpc/platforms/pasemi/setup.c
+++ b/arch/powerpc/platforms/pasemi/setup.c
@@ -44,10 +44,6 @@
 
 #include "pasemi.h"
 
-#if !defined(CONFIG_SMP)
-static void smp_send_stop(void) {}
-#endif
-
 /* SDC reset register, must be pre-mapped at reset time */
 static void __iomem *reset_reg;
 

