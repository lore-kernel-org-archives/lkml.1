Return-Path: <linux-kernel-owner+w=401wt.eu-S1030357AbXEDIgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030357AbXEDIgx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 04:36:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031356AbXEDIgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 04:36:53 -0400
Received: from gw.ac.upc.es ([147.83.30.3]:57911 "EHLO gw.ac.upc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030357AbXEDIgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 04:36:52 -0400
Message-ID: <463AF095.30406@ac.upc.edu>
Date: Fri, 04 May 2007 10:36:37 +0200
From: "Julio M. Merino Vidal" <jmerino@ac.upc.edu>
User-Agent: Thunderbird 1.5.0.10 (Macintosh/20070221)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Per-CPU data as a structure
References: <16C35E62-A26F-49FC-9CD8-7BADFCD97BA5@ac.upc.edu> <p73ps5hx1t2.fsf@bingen.suse.de>
In-Reply-To: <p73ps5hx1t2.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> As far as I can tell, the advantage of percpu is that you can define
>> new "fields" anywhere in the code and independently from the rest of
>> the system. 
>>     
>
> - Independent maintenance as you noted
> - Fast access and relatively compact code
> - Avoids false sharing by keeping cache lines of different CPUs separate
> - Doesn't waste a lot of memory in padding like NR_CPUs arrays usually
> need to to avoid the previous point.
>
> Any replacement that doesn't have these properties too will probably
> be not useful.
>   
Thank you for the details.  I'll try to stick to per-cpu wherever 
possible for now.

Anyway, what do you think about adding the above text to the code (percpu.h
maybe) as documentation?  See the patch below.  (Dunno if the Signed-off-by
line is appropriate as most of the text is yours.)

Signed-off-by: Julio M. Merino Vidal <jmerino@ac.upc.edu>

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 600e3d3..b8e8b8c 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -1,6 +1,21 @@
 #ifndef __LINUX_PERCPU_H
 #define __LINUX_PERCPU_H
 
+/*
+ * percpu provides a mechanism to define variables that are specific to 
each
+ * CPU in the system.
+ *
+ * Each variable is defined as an independent array of NR_CPUS elements.
+ * This approach is used instead of a per-CPU structure because it has the
+ * following advantages:
+ * - Independent maintenance: a source file can define new per-CPU
+ *   variables without distorting others.
+ * - Fast access and relatively compact code.
+ * - Avoids false sharing by keeping cache lines of different CPUs 
separate.
+ * - Doesn't waste a lot of memory in padding like NR_CPUs arrays usually
+ *   need to to avoid the previous point.
+ */
+
 #include <linux/spinlock.h> /* For preempt_disable() */
 #include <linux/slab.h> /* For kmalloc() */
 #include <linux/smp.h>


Kind regards.
