Return-Path: <linux-kernel-owner+w=401wt.eu-S1762304AbYFDTev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762304AbYFDTev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 15:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760624AbYFDTed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 15:34:33 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6915 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762066AbYFDTec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 15:34:32 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5310"; a="3681288"
Message-ID: <4846EE4E.3030103@qualcomm.com>
Date: Wed, 04 Jun 2008 12:34:38 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Jackson <pj@sgi.com>, Andi Kleen <andi@firstfloor.org>,
       ioe-lkml@rameria.de, sivanich@sgi.com, linux-kernel@vger.kernel.org,
       kernel@kolivas.org, dfults@sgi.com, devik@cdi.cz, dino@in.ibm.com,
       emmanuel.pacaud@univ-poitiers.fr, deweerdt@free.fr, mingo@elte.hu,
       colpatch@us.ibm.com, nickpiggin@yahoo.com.au, rostedt@goodmis.org,
       oleg@tv-sign.ru, paulmck@us.ibm.com, menage@google.com,
       rddunlap@osdl.org, suresh.b.siddha@intel.com, tglx@linutronix.de
Subject: Re: Inquiry: Should we remove "isolcpus= kernel boot option? (may
 have realtime uses)
References: <20080601213019.14ea8ef8.pj@sgi.com>	 <1212446707.6269.26.camel@lappy.programming.kicks-ass.net>	 <48447C75.8040203@qualcomm.com>	<200806030156.00155.ioe-lkml@rameria.de>	 <4844BB41.7000605@qualcomm.com>	<4845D825.6000403@qualcomm.com>	 <20080603194148.56dfebe1.pj@sgi.com>	<48461ADA.8020303@qualcomm.com>	 <877id5v1fg.fsf@basil.nowhere.org> <20080604124126.0d281a99.pj@sgi.com>	 <4846DF25.4020300@qualcomm.com> <1212605794.19205.19.camel@lappy.programming.kicks-ass.net>
In-Reply-To: <1212605794.19205.19.camel@lappy.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Peter Zijlstra wrote:
> On Wed, 2008-06-04 at 11:29 -0700, Max Krasnyansky wrote:
>> Paul Jackson wrote:
>>> Andi wrote:
>>>> Right now the system boot could put pages from some daemon in there before any 
>>>> cpusets are set up and there's no easy way to get them away again
>>> We (SGI) routinely handle that need with a custom init program,
>>> invoked with the init= parameter to the booting kernel, which
>>> sets up cpusets and then invokes the normal (real) init program
>>> in a cpuset configured to exclude those CPUs and nodes which we
>>> want to remain unloaded.  For example, on a 256 CPU, 64 node
>>> system, we might have init running on a single node of 4 CPUs,
>>> and leave the remaining 63 nodes and 252 CPUs isolated from all
>>> the usual user level daemons started by init.
>>>
>>> There is no need for additional kernel changes to accomplish this.
>> You do not even need to replace /sbin/init for this, no ?
>> Simply installing custom
>> 	/etc/init.d/create_cpusets
>> with priority 0
>> 	# chkconfig: 12345 0 99
>> will do the job.
>>
>> That script will move init itself into the appropriate cpuset and from then on
>> everything will inherit it.
> 
> The advantage of using a replacement /sbin/init is that you execute
> before the rest of userspace, unlike what you propose.
That does not matter for the cpu placement (ie the end result is the same) but
does matter for memory placement as PaulJ pointed out.

Thanx
Max
