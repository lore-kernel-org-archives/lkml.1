Return-Path: <linux-kernel-owner+w=401wt.eu-S1756909AbXKSSch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909AbXKSSch (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 13:32:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbXKSSc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 13:32:27 -0500
Received: from mu-out-0910.google.com ([209.85.134.190]:33292 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbXKSScZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 13:32:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:reply-to:organization:to:subject:date:user-agent:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:sender;
        b=hGw+NjRHNy6nE6wXrUlHt2eqf1mGX/+18ql9YZPqTvtICmBQevilbYsnQOc67Y/IEtZvaOzmrHgp+UJCIC0O7caBWXBftDgwB1z8H/zJ4iK8i/Zoraf4bvrc2erJdfe1lMPA35911A/NzhYCwxwLRB8GMO6JHoinzNWHY3hz7UY=
From: David <david@livux.com>
Reply-To: david@livux.com
Organization: LiVux
To: linux-kernel@vger.kernel.org
Subject: RE: [patch/backport] CFS scheduler, -v24, for v2.6.24-rc3, v2.6.23.8,v2.6.22.13, v2.6.21.7
Date: Mon, 19 Nov 2007 19:25:11 +0100
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200711191925.12072.david@livux.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> By popular demand, here is release -v24 of the CFS scheduler patch.
> 
> It is a full backport of the latest & greatest scheduler code 
> to v2.6.24-rc3, v2.6.23.8, v2.6.22.13, v2.6.21.7. The patches 
> can be downloaded from the usual place:
> 
>     http://people.redhat.com/mingo/cfs-scheduler/
> 
> There's tons of changes since v22 was released:
> 
>     36 files changed, 2359 insertions(+), 1082 deletions(-)
> 
> that's 187 individual commits from 32 authors.
> 
> So even if CFS v22 worked well for you, please try this 
> release too and report regressions (if any).
> 

Hi Ingo,

Thnx a lot for theses backports...

Ran into this while compiling a 2.6.23.8 with CFS v24

Compiling with CONFIG_FAIR_GROUP_SCHED disabled :

kernel/sysctl.c:305: error: 'sysctl_sched_min_bal_int_shares' undeclared here (not in a function)
kernel/sysctl.c:313: error: 'sysctl_sched_max_bal_int_shares' undeclared here (not in a function)

I made that patch to make it compile.


--- kernel/sysctl.c     2007-11-19 19:08:36.000000000 +0100
+++ kernel.new/sysctl.c 2007-11-19 19:07:49.000000000 +0100
@@ -299,6 +299,7 @@
                .mode           = 644,
                .proc_handler   = &proc_dointvec,
        },
+#ifdef CONFIG_FAIR_GROUP_SCHED
        {
                .ctl_name       = CTL_UNNUMBERED,
                .procname       = "sched_min_bal_int_shares",
@@ -315,6 +316,7 @@
                .mode           = 0644,
                .proc_handler   = &proc_dointvec,
        },
+#endif
 #endif
        {
                .ctl_name       = CTL_UNNUMBERED,



Compiling with CONFIG_FAIR_GROUP_SCHED enabled I get that errors. I have applied other patches, and may be an interaction. I will try to confirm that later :


kernel/sched.c: In function 'rebalance_shares':
kernel/sched.c:7039: error: dereferencing pointer to incomplete type
kernel/sched.c: In function 'load_balance_monitor':
kernel/sched.c:7125: error: 'ndoms_cur' undeclared (first use in this function)
kernel/sched.c:7125: error: (Each undeclared identifier is reported only once
kernel/sched.c:7125: error: for each function it appears in.)
kernel/sched.c:7126: error: 'doms_cur' undeclared (first use in this function)
kernel/sched.c:7132: error: 'struct rq' has no member named 'sd'
kernel/sched.c:7132: warning: type defaults to 'int' in declaration of '_________p1'
kernel/sched.c:7132: error: 'struct rq' has no member named 'sd'
kernel/sched.c:7132: warning: assignment makes pointer from integer without a cast
kernel/sched.c:7132: error: dereferencing pointer to incomplete type
kernel/sched.c:7133: error: dereferencing pointer to incomplete type
kernel/sched.c:7133: error: 'SD_LOAD_BALANCE' undeclared (first use in this function)
kernel/sched.c:7126: warning: unused variable 'cpumap'

-- 
David Rodríguez García
Director Técnico
LiVux I+D S.L.
