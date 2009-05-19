Return-Path: <linux-kernel-owner+w=401wt.eu-S1755000AbZESFTC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000AbZESFTC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 01:19:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753698AbZESFSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 01:18:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60620 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753543AbZESFSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 01:18:54 -0400
Message-ID: <4A124080.7010400@cn.fujitsu.com>
Date: Tue, 19 May 2009 13:15:44 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: add trace_event_read_lock()
References: <4A114806.7090302@cn.fujitsu.com> <20090518135930.GC4704@nowhere> <20090519003505.GK6768@linux.vnet.ibm.com>
In-Reply-To: <20090519003505.GK6768@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> On Mon, May 18, 2009 at 03:59:31PM +0200, Frederic Weisbecker wrote:
>> On Mon, May 18, 2009 at 07:35:34PM +0800, Lai Jiangshan wrote:
>>> I found that there is nothing to protect event_hash in
>>> ftrace_find_event().
>> Actually, rcu protects it, but not enough. We have neither
>> synchronize_rcu() nor rcu_read_lock.
>>
>> So we protect against concurrent hlist accesses.
>> But the event can be removed when a module is unloaded,
>> and that can happen between the time we get the event output
>> callback and the time we actually use it.
> 
> I will ask the stupid question...  Would invoking rcu_barrier() in the
> module-exit function take care of this?  The rcu_barrier() primitive
> waits for all in-flight RCU callbacks to complete execution.
> 
> 							Thanx, Paul
> 

We have no call_rcu* in it.

Thanx, Lai

