Return-Path: <linux-kernel-owner+w=401wt.eu-S965418AbXFFWln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965418AbXFFWln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965405AbXFFWky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:40:54 -0400
Received: from gw.goop.org ([64.81.55.164]:59346 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965402AbXFFWkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:40:52 -0400
Message-ID: <466737E5.9090802@goop.org>
Date: Wed, 06 Jun 2007 15:40:37 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
CC: Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Beulich <jbeulich@novell.com>
Subject: [PATCH]  xen: fix xen-smp.patch: setup_runstate_info
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Somehow an smp_processor_id() survived the transition to passing the
cpu around.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Jan Beulich <jbeulich@novell.com>

---
 arch/i386/xen/time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

===================================================================
--- a/arch/i386/xen/time.c
+++ b/arch/i386/xen/time.c
@@ -110,7 +110,7 @@ static void setup_runstate_info(int cpu)
 	area.addr.v = &per_cpu(runstate, cpu);
 
 	if (HYPERVISOR_vcpu_op(VCPUOP_register_runstate_memory_area,
-			       smp_processor_id(), &area))
+			       cpu, &area))
 		BUG();
 }
 


