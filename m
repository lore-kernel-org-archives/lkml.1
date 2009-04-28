Return-Path: <linux-kernel-owner+w=401wt.eu-S1756806AbZD1Uxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbZD1Uxw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 16:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756397AbZD1Uxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 16:53:41 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:63534 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756175AbZD1Uxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 16:53:40 -0400
Message-ID: <49F76CC4.8050200@oracle.com>
Date: Tue, 28 Apr 2009 13:53:24 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org
Subject: [PATCH] cgroups: make messages more readable
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A01020A.49F76C75.0260:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix some cgroup messages to read better.
Update MAINTAINERS to include mm/*cgroup* files.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 MAINTAINERS      |    1 +
 mm/page_cgroup.c |   14 +++++++-------
 2 files changed, 8 insertions(+), 7 deletions(-)

--- lnx-2630-rc3.orig/mm/page_cgroup.c
+++ lnx-2630-rc3/mm/page_cgroup.c
@@ -83,12 +83,12 @@ void __init page_cgroup_init(void)
 			goto fail;
 	}
 	printk(KERN_INFO "allocated %ld bytes of page_cgroup\n", total_usage);
-	printk(KERN_INFO "please try cgroup_disable=memory option if you"
-	" don't want\n");
+	printk(KERN_INFO "please try 'cgroup_disable=memory' option if you"
+	" don't want memory cgroups\n");
 	return;
 fail:
-	printk(KERN_CRIT "allocation of page_cgroup was failed.\n");
-	printk(KERN_CRIT "please try cgroup_disable=memory boot option\n");
+	printk(KERN_CRIT "allocation of page_cgroup failed.\n");
+	printk(KERN_CRIT "please try 'cgroup_disable=memory' boot option\n");
 	panic("Out of memory");
 }
 
@@ -257,14 +257,14 @@ void __init page_cgroup_init(void)
 		fail = init_section_page_cgroup(pfn);
 	}
 	if (fail) {
-		printk(KERN_CRIT "try cgroup_disable=memory boot option\n");
+		printk(KERN_CRIT "try 'cgroup_disable=memory' boot option\n");
 		panic("Out of memory");
 	} else {
 		hotplug_memory_notifier(page_cgroup_callback, 0);
 	}
 	printk(KERN_INFO "allocated %ld bytes of page_cgroup\n", total_usage);
-	printk(KERN_INFO "please try cgroup_disable=memory option if you don't"
-	" want\n");
+	printk(KERN_INFO "please try 'cgroup_disable=memory' option if you don't"
+	" want memory cgroups\n");
 }
 
 void __meminit pgdat_page_cgroup_init(struct pglist_data *pgdat)
--- lnx-2630-rc3.orig/MAINTAINERS
+++ lnx-2630-rc3/MAINTAINERS
@@ -1519,6 +1519,7 @@ L:	containers@lists.linux-foundation.org
 S:	Maintained
 F:	include/linux/cgroup*
 F:	kernel/cgroup*
+F:	mm/*cgroup*
 
 CORETEMP HARDWARE MONITORING DRIVER
 P:	Rudolf Marek
