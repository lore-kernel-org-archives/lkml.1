Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520AbXJVTo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbXJVTo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 15:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbXJVTou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 15:44:50 -0400
Received: from aun.it.uu.se ([130.238.12.36]:55818 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199AbXJVTou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 15:44:50 -0400
Date: Mon, 22 Oct 2007 21:44:26 +0200 (MEST)
Message-Id: <200710221944.l9MJiQnJ028744@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: Deepak Saxena <dsaxena@plexity.net>
Subject: [PATCH 2.6.23] uninitialised variable in ARM/ixp4xx clockevents code
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Compiling kernel 2.6.23 for an ARM/ixp4xx machine results in:

arch/arm/mach-ixp4xx/common.c: In function 'ixp4xx_set_mode':
arch/arm/mach-ixp4xx/common.c:445: warning: 'opts' may be used uninitialized in this function

The warning is valid: if ixp4xx_set_mode() is called with mode
CLOCK_EVT_MODE_RESUME, then 'opts' will be uninitialised at the
'*IXP4XX_OSRT1 = osrt | opts;' statement.

Initialising opts to zero in this case may not be correct, but
at least it's better than writing random junk to the hardware.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
--
I'm not cc:ing linux-arm-kernel since that's subscribers-only.
This code hasn't changed in 2.6.23-git17.

 arch/arm/mach-ixp4xx/common.c |    1 +
 1 files changed, 1 insertion(+)

--- linux-2.6.23/arch/arm/mach-ixp4xx/common.c.~1~	2007-10-22 20:26:50.000000000 +0200
+++ linux-2.6.23/arch/arm/mach-ixp4xx/common.c	2007-10-22 21:22:10.000000000 +0200
@@ -460,6 +460,7 @@ static void ixp4xx_set_mode(enum clock_e
 		osrt = opts = 0;
 		break;
 	case CLOCK_EVT_MODE_RESUME:
+		opts = 0;
 		break;
 	}
 
