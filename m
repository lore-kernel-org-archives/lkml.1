Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839AbZB0FHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbZB0FHP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 00:07:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750722AbZB0FHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 00:07:00 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46891 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbZB0FG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 00:06:59 -0500
Date: Fri, 27 Feb 2009 14:05:37 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: kenchen@google.com, "menage@google.com" <menage@google.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>, mingo@elte.hu,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [PATCH] change cpuacct usage percpu format
Message-Id: <20090227140537.390905c4.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd like to change cpuacct.usage_percpu format before it's widely used.
Current format is not easy to use in hardware with DR feature.

==
cpuacct.usage_percpu shows per cpu usage information via cgroupfs.
It shows all present cpus information and "whose information ?"
is explained just by index of data implicitly.

IIRC, there is physical cpu hotplug and it can remove
cpus and change present map. Considering a software which records
this information pediodically(like sar.), its better to show id of cpu
in explict way.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: mmotm-2.6.29-Feb24/kernel/sched.c
===================================================================
--- mmotm-2.6.29-Feb24.orig/kernel/sched.c
+++ mmotm-2.6.29-Feb24/kernel/sched.c
@@ -9719,7 +9719,7 @@ static int cpuacct_percpu_seq_read(struc
 
 	for_each_present_cpu(i) {
 		percpu = cpuacct_cpuusage_read(ca, i);
-		seq_printf(m, "%llu ", (unsigned long long) percpu);
+		seq_printf(m, "%d %llu\n", i, (unsigned long long) percpu);
 	}
 	seq_printf(m, "\n");
 	return 0;

