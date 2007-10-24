Return-Path: <linux-kernel-owner+w=401wt.eu-S1757112AbXJXFji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112AbXJXFji (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 01:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754181AbXJXFja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 01:39:30 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:43512 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056AbXJXFja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 01:39:30 -0400
Date: Wed, 24 Oct 2007 11:09:07 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Rusty Russel <rusty@rustcorp.com.au>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Nathan Lynch <ntl@pobox.com>
Subject: [RFC PATCH 5/5] Update get_online_cpus() in Documentation/cpu-hotplug.c 
Message-ID: <20071024053907.GE27074@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20071024052931.GA22722@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024052931.GA22722@in.ibm.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Update the documentation for cpu hotplug to reflect the use
of newly added API's get_online_cpus()/put_online_cpus();

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>

---
 Documentation/cpu-hotplug.txt |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

Index: linux-2.6.23/Documentation/cpu-hotplug.txt
===================================================================
--- linux-2.6.23.orig/Documentation/cpu-hotplug.txt
+++ linux-2.6.23/Documentation/cpu-hotplug.txt
@@ -109,12 +109,13 @@ Never use anything other than cpumask_t 
 	for_each_cpu_mask(x,mask) - Iterate over some random collection of cpu mask.
 
 	#include <linux/cpu.h>
-	lock_cpu_hotplug() and unlock_cpu_hotplug():
+	get_online_cpus() and put_online_cpus():
 
-The above calls are used to inhibit cpu hotplug operations. While holding the
-cpucontrol mutex, cpu_online_map will not change. If you merely need to avoid
-cpus going away, you could also use preempt_disable() and preempt_enable()
-for those sections. Just remember the critical section cannot call any
+The above calls are used to inhibit cpu hotplug operations. While the
+cpu_hotplug.refcount is non zero, the cpu_online_map will not change.
+If you merely need to avoid cpus going away, you could also use
+preempt_disable() and preempt_enable() for those sections.
+Just remember the critical section cannot call any
 function that can sleep or schedule this process away. The preempt_disable()
 will work as long as stop_machine_run() is used to take a cpu down.
 
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
