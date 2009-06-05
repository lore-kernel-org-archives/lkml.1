Return-Path: <linux-kernel-owner+w=401wt.eu-S1755461AbZFEV7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbZFEV7a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 17:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755077AbZFEV7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 17:59:16 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:55357 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754043AbZFEV7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 17:59:15 -0400
X-Amavis-Alert: BAD HEADER, Header field occurs more than once: "Cc" occurs 4
	times
Message-Id: <20090605191852.160435105@gentwo.org>
References: <20090605191819.376530498@gentwo.org>
User-Agent: quilt/0.46-1
Date: Fri, 05 Jun 2009 15:18:29 -0400
From: cl@linux-foundation.org
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu
Cc: rusty@rustcorp.com.au
Cc: davem@davemloft.net
Subject: [this_cpu_xx 10/11] Use this_cpu ops for vm statistics.
Content-Disposition: inline; filename=this_cpu_vmstats
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 include/linux/vmstat.h |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

Index: linux-2.6/include/linux/vmstat.h
===================================================================
--- linux-2.6.orig/include/linux/vmstat.h	2009-06-04 14:23:32.000000000 -0500
+++ linux-2.6/include/linux/vmstat.h	2009-06-04 14:36:04.000000000 -0500
@@ -75,24 +75,23 @@ DECLARE_PER_CPU(struct vm_event_state, v
 
 static inline void __count_vm_event(enum vm_event_item item)
 {
-	__get_cpu_var(vm_event_states).event[item]++;
+	__this_cpu_inc(per_cpu_var(vm_event_states).event[item]);
 }
 
 static inline void count_vm_event(enum vm_event_item item)
 {
-	get_cpu_var(vm_event_states).event[item]++;
+	this_cpu_inc(per_cpu_var(vm_event_states).event[item]);
 	put_cpu();
 }
 
 static inline void __count_vm_events(enum vm_event_item item, long delta)
 {
-	__get_cpu_var(vm_event_states).event[item] += delta;
+	__this_cpu_add(per_cpu_var(vm_event_states).event[item], delta);
 }
 
 static inline void count_vm_events(enum vm_event_item item, long delta)
 {
-	get_cpu_var(vm_event_states).event[item] += delta;
-	put_cpu();
+	this_cpu_add(per_cpu_var(vm_event_states).event[item], delta);
 }
 
 extern void all_vm_events(unsigned long *);

-- 
