Return-Path: <linux-kernel-owner+w=401wt.eu-S1759280AbYCGHqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280AbYCGHqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 02:46:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755135AbYCGHqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 02:46:33 -0500
Received: from mga11.intel.com ([192.55.52.93]:34722 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754748AbYCGHqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 02:46:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,460,1199692800"; 
   d="scan'208";a="304294476"
Subject: Re: [BUG 2.6.25-rc3] scheduler/hotplug: some processes are
	dealocked when cpu is set to offline
From: Yi Yang <yi.y.yang@intel.com>
Reply-To: yi.y.yang@intel.com
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Gautham R Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1204641443.3842.46.camel@yangyi-dev.bj.intel.com>
References: <1204483329.3607.8.camel@yangyi-dev.bj.intel.com>
	 <20080303153154.GA11288@in.ibm.com>
	 <1204555505.3842.4.camel@yangyi-dev.bj.intel.com>
	 <20080304052613.GA28632@in.ibm.com>  <20080304150107.GA564@tv-sign.ru>
	 <1204641443.3842.46.camel@yangyi-dev.bj.intel.com>
Content-Type: text/plain
Organization: Intel
Date: Fri, 07 Mar 2008 04:05:10 +0800
Message-Id: <1204833910.3842.58.camel@yangyi-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found priority of some processes is always 0 but they are highly
related to this kind of deadlock.

What does Priority 0 mean? When and in which case is it's priority
changed to 0? When can it's priority be restored to one higher value.

A simple script to get priority 0:

===================================================================
#!/bin/sh

for file in `ls /proc/*/sched`
do
        prio=`grep prio $file | awk '{print $3;}'`
        if [ "X$prio" == "X0" ] ; then
                echo "`head -n 1 $file | awk '{print $1}'`: $prio"
        fi
done
==================================================================

[root@harwich-rh ~]# ./lsprio
migration/3: 0
migration/4: 0
migration/5: 0
migration/6: 0
migration/7: 0
migration/8: 0
migration/9: 0
migration/10: 0
migration/11: 0
migration/12: 0
migration/0: 0
migration/13: 0
migration/14: 0
migration/15: 0
grep: /proc/5244/sched: No such file or directory
kstopmachine: 0
kstopmachine: 0
kstopmachine: 0
kstopmachine: 0
kstopmachine: 0
kstopmachine: 0
kstopmachine: 0
kstopmachine: 0
kstopmachine: 0
kstopmachine: 0
kstopmachine: 0
kstopmachine: 0
kstopmachine: 0
kstopmachine: 0
kstopmachine: 0
kstopmachine: 0
watchdog/1: 0
migration/2: 0

[root@harwich-rh ~]# ps aux | grep "R<"
root         8  0.0  0.0      0     0 ?        R<   19:29   0:00
[watchdog/1]
root      6987  0.0  0.0  61144   708 pts/2    R+   20:16   0:00 grep R<
[root@harwich-rh ~]#



