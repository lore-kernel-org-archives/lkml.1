Return-Path: <linux-kernel-owner+w=401wt.eu-S1755939AbYFCXsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbYFCXsH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 19:48:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbYFCXry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 19:47:54 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22468 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbYFCXrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 19:47:53 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5309"; a="3482982"
Message-ID: <4845D825.6000403@qualcomm.com>
Date: Tue, 03 Jun 2008 16:47:49 -0700
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Oeser <ioe-lkml@rameria.de>, Dimitri Sivanich <sivanich@sgi.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Jackson <pj@sgi.com>,
       linux-kernel@vger.kernel.org, Con Kolivas <kernel@kolivas.org>,
       "Derek L. Fults" <dfults@sgi.com>, devik <devik@cdi.cz>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Emmanuel Pacaud <emmanuel.pacaud@univ-poitiers.fr>,
       Frederik Deweerdt <deweerdt@free.fr>, Ingo Molnar <mingo@elte.hu>,
       Matthew Dobson <colpatch@us.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, rostedt@goodmis.org,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Paul Menage <menage@google.com>, "Randy.Dunlap" <rddunlap@osdl.org>,
       suresh.b.siddha@intel.com, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Inquiry: Should we remove "isolcpus= kernel boot option? (may
 have realtime uses)
References: <20080601213019.14ea8ef8.pj@sgi.com> <1212446707.6269.26.camel@lappy.programming.kicks-ass.net> <48447C75.8040203@qualcomm.com> <200806030156.00155.ioe-lkml@rameria.de> <4844BB41.7000605@qualcomm.com>
In-Reply-To: <4844BB41.7000605@qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I would really appreciate some way to keep the kernel from using 
>> a CPU at all to do fault isolation. If possible not even booting it.
> How does isolcpu= boot option helps in this case ?
> I suppose the closes option is maxcpus=. We can probably add ignorecpus= or
> something to handle your use case but it has nothing to do with isolcpus=.

btw Ingo, I just realized that maxcpu= option is exactly what you need.
Here is how you can use it.
Boot your system with maxcpus=1. That way the kernel will only bring up 
processor 0. I'm assuming cpu0 is "good" otherwise your system is totally 
busted :). Other cpus will stay off-line and will not be initialized.
Then once the system boots you can selectively bring "good" processors online 
by doing
	echo 1 > /sys/devices/system/cpu/cpuN/online

This actually solves the case you're talking about (ie ignoring bad 
processors) instead of partially covering it with isolcpus=.

Dimitri, you can probably use that too. ie Boot the thing with most CPUs 
offline and then bring them online. That way you'll know for sure that no 
timers, works, hard-/soft-irqs, etc are running on them.

So I expect two ACKs for isolcpu= removal from both of you, in bold please :)

Max
