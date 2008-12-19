Return-Path: <linux-kernel-owner+w=401wt.eu-S1756626AbYLSWK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626AbYLSWK0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 17:10:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755720AbYLSV4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 16:56:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34157 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755705AbYLSV4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 16:56:53 -0500
Date: Fri, 19 Dec 2008 13:55:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
       venkatesh.pallipadi@intel.com, a.p.zijlstra@chello.nl, mingo@elte.hu,
       dipankar@in.ibm.com, balbir@linux.vnet.ibm.com,
       vatsa@linux.vnet.ibm.com, ego@in.ibm.com, andi@firstfloor.org,
       davecb@sun.com, tconnors@astro.swin.edu.au, maxk@qualcomm.com,
       gregory.haskins@gmail.com, pavel@suse.cz, svaidy@linux.vnet.ibm.com,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH v7 4/8] sched: nominate preferred wakeup cpu
Message-Id: <20081219135508.9c6217ba.akpm@linux-foundation.org>
In-Reply-To: <20081218175622.29812.69201.stgit@drishya.in.ibm.com>
References: <20081218175313.29812.4781.stgit@drishya.in.ibm.com>
	<20081218175622.29812.69201.stgit@drishya.in.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Dec 2008 23:26:22 +0530
Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:

> When the system utilisation is low and more cpus are idle,
> then the process waking up from sleep should prefer to
> wakeup an idle cpu from semi-idle cpu package (multi core
> package) rather than a completely idle cpu package which
> would waste power.
> 
> Use the sched_mc balance logic in find_busiest_group() to
> nominate a preferred wakeup cpu.
> 
> This info can be sored in appropriate sched_domain, but
> updating this info in all copies of sched_domain is not
> practical.  Hence this information is stored in root_domain
> struct which is one copy per partitioned sched domain.
> The root_domain can be accessed from each cpu's runqueue
> and there is one copy per partitioned sched domain.
> 

kernel/sched.c: In function 'find_busiest_group':
kernel/sched.c:3403: warning: passing argument 1 of '__first_cpu' from incompatible pointer type

Due to

	first_cpu(group_leader->cpumask);

apparently because Rusty changed sched_group.cpumask into a plain old
array and nobody tests their stuff against the tree into which it is
actually integrated :(

kernel/sched.c: In function 'schedule':
kernel/sched.c:3679: warning: 'active_balance' may be used uninitialized in this function

This warning is correct - the code is buggy.
