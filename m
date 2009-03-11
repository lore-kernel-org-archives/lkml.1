Return-Path: <linux-kernel-owner+w=401wt.eu-S1753162AbZCKGFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbZCKGFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 02:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbZCKGFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 02:05:10 -0400
Received: from ozlabs.org ([203.10.76.45]:37689 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644AbZCKGFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 02:05:09 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: [PATCH] cpumask: make Xen use the new operators.
Date: Wed, 11 Mar 2009 16:35:05 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903111635.05924.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

In particular, *map are deprecated, and you have to use the accessors
as *mask are const.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 drivers/xen/cpu_hotplug.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/cpu_hotplug.c b/drivers/xen/cpu_hotplug.c
--- a/drivers/xen/cpu_hotplug.c
+++ b/drivers/xen/cpu_hotplug.c
@@ -10,7 +10,7 @@ static void enable_hotplug_cpu(int cpu)
 	if (!cpu_present(cpu))
 		arch_register_cpu(cpu);
 
-	cpu_set(cpu, cpu_present_map);
+	set_cpu_present(cpu, true);
 }
 
 static void disable_hotplug_cpu(int cpu)
@@ -18,7 +18,7 @@ static void disable_hotplug_cpu(int cpu)
 	if (cpu_present(cpu))
 		arch_unregister_cpu(cpu);
 
-	cpu_clear(cpu, cpu_present_map);
+	set_cpu_present(cpu, false);
 }
 
 static void vcpu_hotplug(unsigned int cpu)
