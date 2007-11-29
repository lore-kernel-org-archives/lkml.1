Return-Path: <linux-kernel-owner+w=401wt.eu-S1759724AbXK2IaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759724AbXK2IaF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 03:30:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754684AbXK2I3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 03:29:53 -0500
Received: from posti6.jyu.fi ([130.234.4.43]:50963 "EHLO posti6.jyu.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbXK2I3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 03:29:52 -0500
X-Greylist: delayed 1978 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Nov 2007 03:29:51 EST
Date: Thu, 29 Nov 2007 09:56:39 +0200 (EET)
From: Tero Roponen <teanropo@jyu.fi>
X-X-Sender: teanropo@jalava.cc.jyu.fi
To: johnstul@us.ibm.com, tglx@linutronix.de
cc: linux-kernel@vger.kernel.org
Subject: TSC blacklisting is unneeded?
Message-ID: <Pine.LNX.4.64.0711290953340.23514@jalava.cc.jyu.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

In January 2006 I had problems with the TSC clocksource, that
were fixed by adding a blacklist: http://lkml.org/lkml/2006/1/19/362

Recently I tested 2.6.24-rc3-git1 by commenting out the only
entry in the bad_tsc_dmi_table, and everything still worked
without it:

--- dmesg.with	2007-11-28 10:58:21.000000000 +0200
+++ dmesg.without	2007-11-28 11:08:10.000000000 +0200
@@ -31,8 +31,7 @@
-Detected 265.284 MHz processor.
-IBM Thinkpad 380XD detected: marking TSC unstable.
+Detected 265.275 MHz processor.
@@ -102,7 +101,7 @@
-Time: pit clocksource has been installed.
+Time: tsc clocksource has been installed.
@@ -140,8 +139,9 @@
-Clocksource tsc unstable (delta = -234073763 ns)
+Clocksource tsc unstable (delta = -234191628 ns)
 ata1.00: configured for UDMA/33
+Time: pit clocksource has been installed.

So it seems that the blacklisting is not needed anymore,
as the unstability is now detected automatically.

-- 
Tero Roponen, <tero.roponen@gmail.com>
