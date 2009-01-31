Return-Path: <linux-kernel-owner+w=401wt.eu-S1758164AbZAaBn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164AbZAaBn2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 20:43:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757714AbZAaBmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 20:42:39 -0500
Received: from gw.goop.org ([64.81.55.164]:36872 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757550AbZAaBmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 20:42:36 -0500
Message-ID: <4983AC8A.6050501@goop.org>
Date: Fri, 30 Jan 2009 17:42:34 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, Tejun Heo <htejun@gmail.com>,
       Brian Gerst <brgerst@gmail.com>
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


