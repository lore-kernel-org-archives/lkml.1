Return-Path: <linux-kernel-owner+w=401wt.eu-S1755126AbZB0HbD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126AbZB0HbD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 02:31:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757438AbZB0Hau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 02:30:50 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33809 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbZB0Hat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 02:30:49 -0500
Date: Fri, 27 Feb 2009 16:29:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       kenchen@google.com, "menage@google.com" <menage@google.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>, mingo@elte.hu,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [PATCH] change cpuacct usage percpu format v2
Message-Id: <20090227162928.6225fc80.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090227140537.390905c4.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090227140537.390905c4.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

cpuacct.usage_percpu shows per cpu usage information via cgroupfs.
It shows all "present" cpus information and "whose information ?"
is explained just by index of data implicitly.

IIRC, there is physical cpu hotplug system and it can remove
cpus and change map. Considering a software which records
this information pediodically(like sar), its better to show id of cpu
in explict way.

Changelog: v1 -> v2
 - added ":" instead of " " as split charactor.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
Index: mmotm-2.6.29-Feb26/kernel/sched.c
===================================================================
--- mmotm-2.6.29-Feb26.orig/kernel/sched.c
+++ mmotm-2.6.29-Feb26/kernel/sched.c
@@ -9719,7 +9719,7 @@ static int cpuacct_percpu_seq_read(struc
 
 	for_each_present_cpu(i) {
 		percpu = cpuacct_cpuusage_read(ca, i);
-		seq_printf(m, "%llu ", (unsigned long long) percpu);
+		seq_printf(m, "%d:%llu\n", i, (unsigned long long) percpu);
 	}
 	seq_printf(m, "\n");
 	return 0;

