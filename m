Return-Path: <linux-kernel-owner+w=401wt.eu-S1756515AbZFHOZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515AbZFHOZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 10:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755421AbZFHOZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 10:25:23 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:46979 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756120AbZFHOZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 10:25:21 -0400
Date: Mon, 8 Jun 2009 07:25:20 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
       dipankar@in.ibm.com
Subject: Re: [PATCH] cpuhotplug: introduce try_get_online_cpus() take 2
Message-ID: <20090608142520.GA6961@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4A1F9CEA.1070705@cn.fujitsu.com> <20090530015342.GA21502@linux.vnet.ibm.com> <20090530043739.GA12157@in.ibm.com> <4A27708C.6030703@cn.fujitsu.com> <20090605153714.GB6778@linux.vnet.ibm.com> <20090608041934.GB17979@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090608041934.GB17979@in.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 09:49:34AM +0530, Gautham R Shenoy wrote:
> Hi Paul,
> 
> On Fri, Jun 05, 2009 at 08:37:14AM -0700, Paul E. McKenney wrote:
> > 
> > One question for Gautham Shenoy -- are non-atomic CPU-hotplug notifiers
> > always invoked from the task that did the cpu_hotplug_begin()?
> 
> Except for the notifiers handling two events, rest of the notifiers
> are always invoked from the task that did the cpu_hotplug_begin().
> 
> The two events are CPU_DYING which is called from the context of the
> stop_machine_thread and CPU_STARTING which is called from the context of
> the idle thread on the CPU that has just come up. The notifiers handling
> these two events are expected to be atomic.
> 
> > If so, well and good.  If not, then it would not be possible to
> > expedite RCU grace periods from within CPU-hotplug notifiers.
> 
> I hope this would be good enough :-)

Works for me!!  ;-)

							Thanx, Paul
