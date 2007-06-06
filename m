Return-Path: <linux-kernel-owner+w=401wt.eu-S934248AbXFFBjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934248AbXFFBjK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 21:39:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933476AbXFFBiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 21:38:19 -0400
Received: from 207.47.60.147.static.nextweb.net ([207.47.60.147]:40656 "EHLO
	rpc.xensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933298AbXFFBiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 21:38:17 -0400
X-Greylist: delayed 848 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jun 2007 21:38:16 EDT
Message-ID: <46660CAA.9000206@xensource.com>
Date: Tue, 05 Jun 2007 18:23:54 -0700
From: Jeremy Fitzhardinge <jeremy@xensource.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] xen: disable all non-virtual devices
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jun 2007 01:24:08.0186 (UTC) FILETIME=[61150DA0:01C7A7D9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A domU Xen environment has no non-virtual drivers, so make sure
they're all disabled at once.  This noticeably speeds up boot time.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>

diff -r c79da0042c7d arch/i386/xen/setup.c
--- a/arch/i386/xen/setup.c	Tue Jun 05 18:17:30 2007 -0700
+++ b/arch/i386/xen/setup.c	Tue Jun 05 18:17:59 2007 -0700
@@ -93,4 +93,6 @@ void __init xen_arch_setup(void)
 	/* fill cpus_possible with all available cpus */
 	xen_fill_possible_map();
 #endif
+
+	paravirt_disable_iospace();
 }


