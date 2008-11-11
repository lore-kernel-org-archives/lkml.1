Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096AbYKKNoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbYKKNoH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 08:44:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755639AbYKKNnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 08:43:55 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:13010 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855AbYKKNny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 08:43:54 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [RFC PATCH v3 3/5] sched: nominate preferred wakeup cpu
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, David Collier-Brown <davecb@sun.com>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>,
       "gregory.haskins" <gregory.haskins@gmail.com>
In-Reply-To: <20081110183326.562.37718.stgit@drishya.in.ibm.com>
References: <20081110181526.562.69941.stgit@drishya.in.ibm.com>
	 <20081110183326.562.37718.stgit@drishya.in.ibm.com>
Content-Type: text/plain
Date: Tue, 11 Nov 2008 14:43:39 +0100
Message-Id: <1226411019.7685.1767.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-11 at 00:03 +0530, Vaidyanathan Srinivasan wrote:
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
> practical.  For now lets try with a per-cpu variable
> pointing to a common storage in partition sched domain
> attribute.  Global variable may not work in partitioned
> sched domain case.

Would it make sense to place the preferred_wakeup_cpu stuff in the
root_domain structure we already have?

