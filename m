Return-Path: <linux-kernel-owner+w=401wt.eu-S1752697AbZCKIve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbZCKIve (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 04:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbZCKIvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 04:51:25 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:56320 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbZCKIvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 04:51:24 -0400
Date: Wed, 11 Mar 2009 09:47:19 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: akataria@vmware.com
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Process accounting in interrupt diabled cases
Message-ID: <20090311094719.0fe3de82@skybase>
In-Reply-To: <1236416374.23222.52.camel@alok-dev1>
References: <1236380615.4637.67.camel@alok-dev1>
	<49B1C1D1.4070603@goop.org>
	<1236387583.4558.22.camel@alok-dev1>
	<49B1CD54.8070805@goop.org>
	<1236416374.23222.52.camel@alok-dev1>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 07 Mar 2009 00:59:33 -0800
Alok Kataria <akataria@vmware.com> wrote:

> Yes that's alright, all that time when vcpu was idle and scheduled out
> will anyways be accounted as idle time, as mentioned in my earlier mail
> ( and if my understanding is not wrong) this is handled by
> tick_nohz_restart_sched_tick.
> 
> But i was talking about a case, where we have this code
> 	local_irq_disable()
> 	some_work()
> 	local_irq_enable()
> 
> If this some_work() executed for say 2 ticks, shouldn't the process
> executing this be accounted 2 ticks of system time ? According to my
> understanding, we will account a single tick for this, right ? 

Don't know too much about x86 and Xen but on s390 the tick is just a
convenient way to transfer the accumulated cpu time to the process and
the cpustat fields. The cpu time that has been used is determined by
the cpu timer. This would still work without any ticks at all, although
then you'd have to wait for the next context switch until the
accumulated cpu time gets visible in the process and cpustat.
In short: the above example just works fine for us.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

