Return-Path: <linux-kernel-owner+w=401wt.eu-S1752644AbXBFDwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbXBFDwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 22:52:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbXBFDwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 22:52:41 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:49461 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752644AbXBFDwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 22:52:40 -0500
Date: Mon, 5 Feb 2007 19:52:33 -0800
Message-Id: <200702060352.l163qX34000721@zach-dev.vmware.com>
Subject: [PATCH 1/11] Make hrtimers friendly to vmi
From: Zachary Amsden <zach@vmware.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>
X-OriginalArrivalTime: 06 Feb 2007 03:52:33.0739 (UTC) FILETIME=[3BA299B0:01C749A2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Highres timers no longer breaks with VMI turned on because the
required function is now exported even with hrtimers turned on.
Until hrtimers becomes the default for i386, we must still support
both timer modes, NO_HZ, and also NO_IDLE_HZ, which is paravirt
specific.

Signed-off-by: Zachary Amsden <zach@vmware.com>

diff -r 4141f5f8c54e arch/i386/Kconfig
--- a/arch/i386/Kconfig	Thu Feb 01 18:46:27 2007 -0800
+++ b/arch/i386/Kconfig	Thu Feb 01 18:53:21 2007 -0800
@@ -219,7 +219,7 @@ config PARAVIRT
 
 config VMI
 	bool "VMI Paravirt-ops support"
-	depends on PARAVIRT && !NO_HZ
+	depends on PARAVIRT
 	default y
 	help
 	  VMI provides a paravirtualized interface to multiple hypervisors
