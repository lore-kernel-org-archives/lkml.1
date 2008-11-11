Return-Path: <linux-kernel-owner+w=401wt.eu-S1756675AbYKKNr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675AbYKKNr3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 08:47:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755894AbYKKNrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 08:47:20 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:3777 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855AbYKKNrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 08:47:19 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [RFC PATCH v3 5/5] sched: activate active load balancing in
 new idle cpus
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
       Max Krasnyansky <maxk@qualcomm.com>
In-Reply-To: <20081110183343.562.72751.stgit@drishya.in.ibm.com>
References: <20081110181526.562.69941.stgit@drishya.in.ibm.com>
	 <20081110183343.562.72751.stgit@drishya.in.ibm.com>
Content-Type: text/plain
Date: Tue, 11 Nov 2008 14:47:15 +0100
Message-Id: <1226411235.7685.1775.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-11 at 00:03 +0530, Vaidyanathan Srinivasan wrote:
> Active load balancing is a process by which migration thread
> is woken up on the target CPU in order to pull current
> running task on another package into this newly idle
> package.
> 
> This method is already in use with normal load_balance(),
> this patch introduces this method to new idle cpus when
> sched_mc is set to POWERSAVINGS_BALANCE_WAKEUP.
> 
> This logic provides effective consolidation of short running
> daemon jobs in a almost idle system
> 
> The side effect of this patch may be ping-ponging of tasks
> if the system is moderately utilised. May need to adjust the
> iterations before triggering.

OK, I'm so not getting this patch..

if normal newly idle balancing fails that means the other runqueue has
only a single task on it (or some other really stubborn stuff), so then
you go move that one task that is already running, from one cpu to
another.

_why_?

The only answer I can come up with is that you prefer one cpu's
idle-ness over another - which makes sense, as you try to get whole
packages idle.

But I'm not seeing where that package logic is hidden..

