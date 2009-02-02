Return-Path: <linux-kernel-owner+w=401wt.eu-S1759818AbZBBV43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759818AbZBBV43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 16:56:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759578AbZBBV4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 16:56:04 -0500
Received: from gw.goop.org ([64.81.55.164]:42438 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759559AbZBBV4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 16:56:02 -0500
Message-ID: <49876BEA.2000307@goop.org>
Date: Mon, 02 Feb 2009 13:55:54 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [PATCH 3/3] xen: use direct ops on 64-bit
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable the use of the direct vcpu-access operations on 64-bit.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

===================================================================
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -116,14 +116,7 @@
  *
  * 0: not available, 1: available
  */
-static int have_vcpu_info_placement =
-#ifdef CONFIG_X86_32
-	1
-#else
-	0
-#endif
-	;
-
+static int have_vcpu_info_placement = 1;
 
 static void xen_vcpu_setup(int cpu)
 {
@@ -1644,11 +1637,6 @@
 	machine_ops = xen_machine_ops;
 
 #ifdef CONFIG_X86_64
-	/* Disable until direct per-cpu data access. */
-	have_vcpu_info_placement = 0;
-#endif
-
-#ifdef CONFIG_X86_64
 	/*
 	 * Setup percpu state.  We only need to do this for 64-bit
          * because 32-bit already has %fs set properly.


