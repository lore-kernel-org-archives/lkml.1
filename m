Return-Path: <linux-kernel-owner+w=401wt.eu-S1763333AbXGWJPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763333AbXGWJPf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 05:15:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbXGWJP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 05:15:28 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:53661 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbXGWJP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 05:15:26 -0400
Subject: Re: [PATCH] virtual sched_clock() for s390
From: Jan Glauber <jang@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>, vatsa@linux.vnet.ibm.com,
       mschwid2@linux.vnet.ibm.com, efault@gmx.de, dmitry.adamushko@gmail.com,
       anton@samba.org
In-Reply-To: <20070720072245.GA4020@elte.hu>
References: <1184842661.6546.14.camel@localhost.localdomain>
	 <469F8342.7060000@goop.org> <20070719160025.GA31815@elte.hu>
	 <18080.2390.42425.852087@cargo.ozlabs.ibm.com>
	 <20070720072245.GA4020@elte.hu>
Content-Type: text/plain
Date: Mon, 23 Jul 2007 09:15:49 +0000
Message-Id: <1185182149.5783.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-20 at 09:22 +0200, Ingo Molnar wrote:
> * Paul Mackerras <paulus@samba.org> wrote:
> > As with s390, 64-bit PowerPC also uses CONFIG_VIRT_CPU_ACCOUNTING. 
> > That affects how tsk->utime and tsk->stime are accumulated (we call 
> > account_user_time and account_system_time directly rather than calling 
> > update_process_times) as well as the system hardirq/softirq time, idle 
> > time, and stolen time.
> 
> tsk->utime and tsk->stime is only used for a single purpose: to 
> determine the 'split' factor of how to split up the precise total time 
> between user and system time.
> 
> > When you say "precise task statistics for /proc", where are they 
> > accumulated?  I don't see any changes to the way that tsk->utime and 
> > ctime are computed.
> 
> we now use p->se.sum_exec_runtime that measures (in nanoseconds) the 
> precise amount of time spent executing (sum of system and user time) - 
> and ->stime and ->utime is used to determine the 'split'. [this allows 
> us to gather ->stime and ->utime via low-resolution sampling, while 
> keeping the 'total' precise. Accounting at every system entry point 
> would be quite expensive on most platforms.]

Using se.sum_exec_runtime to generate ->utime and ->stime breaks
the process accounting we have on s390 (and probably on PowerPC too).
With CONFIG_VIRT_CPU_ACCOUNTING we already have precise values in
->utime and ->stime. Can we make the calculation of the CFS-based time
values conditional by CONFIG_VIRT_CPU_ACCOUNTING?

Jan

> 	Ingo
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

