Return-Path: <linux-kernel-owner+w=401wt.eu-S1758782AbZEMPCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758782AbZEMPCW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 11:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753256AbZEMPCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 11:02:12 -0400
Received: from viefep18-int.chello.at ([62.179.121.38]:39972 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756717AbZEMPCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 11:02:11 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [RFC PATCH v2 0/2] Saving power by cpu evacuation
 sched_max_capacity_pct=n
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
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
In-Reply-To: <20090513150100.GW19296@one.firstfloor.org>
References: <20090513130541.21440.33364.stgit@drishya.in.ibm.com>
	 <20090513143550.GU19296@one.firstfloor.org>
	 <1242225402.26820.23.camel@twins>
	 <20090513144659.GV19296@one.firstfloor.org>
	 <1242226219.26820.26.camel@twins>
	 <20090513150100.GW19296@one.firstfloor.org>
Content-Type: text/plain
Date: Wed, 13 May 2009 17:02:06 +0200
Message-Id: <1242226927.26820.30.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-13 at 17:01 +0200, Andi Kleen wrote:
> > >From what I've been told its popular to over-commit the cooling capacity
> > in a rack, so that a number of servers can run at full thermal capacity
> > but not all.
> 
> Yes. But in this case you don't want to use throttling, you want
> to use p-states which actually safe power unlike throttling.
> 
> > I've also been told that hardware sucks at throttling, 
> 
> Throttling is not really something you should use in normal 
> operation, it's just a emergency measure. For that it works
> quite well, but you really don't want it in normal operation.
> 
> > therefore people
> > want to fix the OS so as to limit the thermal capacity and avoid the
> > hardware throttle from kicking in, whilst still not exceeding the rack
> > capacity or similar nonsense.
> 
> Yes that's fine and common, but you actually need to save power for this,
> which throttling doesn't do.
> 
> My understanding this work is a extension of the existing
> sched_mc_power_savings features that tries to be optionally more 
> aggressive to keep complete package idle so that package level
> power saving kicks in.
> 
> I'm just requesting that they don't call that throttling.

Ah no, this work differs in that regard in that it actually 'generates'
idle time, instead of optimizing idle time.

Therefore it takes actual cpu time away from real work, which is
throttling. Granted, one could call it limiting or similar, but
throttling is a correct name.

