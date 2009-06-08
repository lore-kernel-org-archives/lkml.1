Return-Path: <linux-kernel-owner+w=401wt.eu-S1751801AbZFHET7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801AbZFHET7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 00:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750719AbZFHETu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 00:19:50 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:60611 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbZFHETu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 00:19:50 -0400
Date: Mon, 8 Jun 2009 09:49:34 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
       dipankar@in.ibm.com
Subject: Re: [PATCH] cpuhotplug: introduce try_get_online_cpus() take 2
Message-ID: <20090608041934.GB17979@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <4A1F9CEA.1070705@cn.fujitsu.com> <20090530015342.GA21502@linux.vnet.ibm.com> <20090530043739.GA12157@in.ibm.com> <4A27708C.6030703@cn.fujitsu.com> <20090605153714.GB6778@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090605153714.GB6778@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Fri, Jun 05, 2009 at 08:37:14AM -0700, Paul E. McKenney wrote:
> 
> One question for Gautham Shenoy -- are non-atomic CPU-hotplug notifiers
> always invoked from the task that did the cpu_hotplug_begin()?

Except for the notifiers handling two events, rest of the notifiers
are always invoked from the task that did the cpu_hotplug_begin().

The two events are CPU_DYING which is called from the context of the
stop_machine_thread and CPU_STARTING which is called from the context of
the idle thread on the CPU that has just come up. The notifiers handling
these two events are expected to be atomic.

> If so, well and good.  If not, then it would not be possible to
> expedite RCU grace periods from within CPU-hotplug notifiers.

I hope this would be good enough :-)
> 
> 							Thanx, Paul
> 

-- 
Thanks and Regards
gautham
