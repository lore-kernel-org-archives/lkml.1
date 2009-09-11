Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbZIKHyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbZIKHyJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 03:54:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbZIKHyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 03:54:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61861 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754070AbZIKHyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 03:54:08 -0400
Message-ID: <4AAA01F4.3050502@cn.fujitsu.com>
Date: Fri, 11 Sep 2009 15:53:24 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Gautham Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Jiri Slaby <jirislaby@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Miao Xie <miaox@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] resend, cpuset/hotplug fixes
References: <20090910192153.GA584@redhat.com>	 <1252615996.7205.99.camel@laptop>  <4AA9F902.4030306@cn.fujitsu.com> <1252654410.7126.1.camel@laptop>
In-Reply-To: <1252654410.7126.1.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Fri, 2009-09-11 at 15:15 +0800, Lai Jiangshan wrote:
>> One other minor thing:
>> Oleg's patch may introduce a trouble in PREEEMPT_RT tree, because
>> spinlock in RT is also mutex. Likely I'm wrong.
> 
> But they have priority-inheritance, hence you cannot create a deadlock
> through preemption. If the kstopmachine thread blocks on a mutex, the
> owner gets boosted to kstopmachine's prio and runs to completion, after
> that kstopmachine continues.
> 

The deadlock is because the owner is at the dead cpu, It's not because
the owner's prio is low. priority-inheritance can't help it.

I think we need to use a raw spinlock.

