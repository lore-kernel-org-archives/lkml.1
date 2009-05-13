Return-Path: <linux-kernel-owner+w=401wt.eu-S1760658AbZEMOz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760658AbZEMOz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 10:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758531AbZEMOzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 10:55:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53903 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760234AbZEMOzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 10:55:38 -0400
Date: Wed, 13 May 2009 17:01:00 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH v2 0/2] Saving power by cpu evacuation sched_max_capacity_pct=n
Message-ID: <20090513150100.GW19296@one.firstfloor.org>
References: <20090513130541.21440.33364.stgit@drishya.in.ibm.com> <20090513143550.GU19296@one.firstfloor.org> <1242225402.26820.23.camel@twins> <20090513144659.GV19296@one.firstfloor.org> <1242226219.26820.26.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242226219.26820.26.camel@twins>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >From what I've been told its popular to over-commit the cooling capacity
> in a rack, so that a number of servers can run at full thermal capacity
> but not all.

Yes. But in this case you don't want to use throttling, you want
to use p-states which actually safe power unlike throttling.

> I've also been told that hardware sucks at throttling, 

Throttling is not really something you should use in normal 
operation, it's just a emergency measure. For that it works
quite well, but you really don't want it in normal operation.

> therefore people
> want to fix the OS so as to limit the thermal capacity and avoid the
> hardware throttle from kicking in, whilst still not exceeding the rack
> capacity or similar nonsense.

Yes that's fine and common, but you actually need to save power for this,
which throttling doesn't do.

My understanding this work is a extension of the existing
sched_mc_power_savings features that tries to be optionally more 
aggressive to keep complete package idle so that package level
power saving kicks in.

I'm just requesting that they don't call that throttling.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
