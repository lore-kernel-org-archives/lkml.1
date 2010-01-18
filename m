Return-Path: <linux-kernel-owner+w=401wt.eu-S1752443Ab0ARJ5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443Ab0ARJ5Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 04:57:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751469Ab0ARJ5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 04:57:24 -0500
Received: from ozlabs.org ([203.10.76.45]:53982 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898Ab0ARJ5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 04:57:23 -0500
Date: Mon, 18 Jan 2010 20:55:27 +1100
From: Anton Blanchard <anton@samba.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, balajirrao@gmail.com, dhaval@linux.vnet.ibm.com,
       tglx@linutronix.de, kamezawa.hiroyu@jp.fujitsu.com,
       akpm@linux-foundation.org, Tony Luck <tony.luck@intel.com>,
       Fenghua Yu <fenghua.yu@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com
Subject: Re: [PATCH] sched: cpuacct: Use bigger percpu counter batch values
 for stats counters
Message-ID: <20100118095527.GV12666@kryten>
References: <20090512102412.GG6351@balbir.in.ibm.com>
 <20090512102939.GB11714@elte.hu>
 <20090512193656.D647.A69D9226@jp.fujitsu.com>
 <20090716081010.GB3134@in.ibm.com>
 <20090716083948.GA2950@kryten>
 <20090820051038.GF21100@kryten>
 <20100118044142.GS12666@kryten>
 <20100118104213.64231c1e@mschwide.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100118104213.64231c1e@mschwide.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Martin,

> For s390 the jiffies_to_cputime is a compile time constant. No need to
> initialize it at runtime, no? 

Indeed it is, I didn't look closely enough. Same with ia64 so no work to
do on either arch :)

> The patch itself trades some accuracy (larger cpu accounting value that
> are stored per-cpu) against runtime overhead (spinlock to transfer the
> value to the global variable in __percpu_counter_add). Did you
> calculate how big the loss in accuracy is?

The idea is we are already batching percpu_counter_batch jiffies, so
with CONFIG_VIRT_CPU_ACCOUNTING we batch the equivalent amount in
cputime.

Anton
