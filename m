Return-Path: <linux-kernel-owner+w=401wt.eu-S1755706AbZKTIVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706AbZKTIVd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 03:21:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754565AbZKTIVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 03:21:32 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63225 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754287AbZKTIVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 03:21:32 -0500
Message-ID: <4B065169.7080603@cn.fujitsu.com>
Date: Fri, 20 Nov 2009 16:20:57 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH 1/2] perf: Add 'perf kmem' tool
References: <4B064AF5.9060208@cn.fujitsu.com> <20091120081440.GA19778@elte.hu>
In-Reply-To: <20091120081440.GA19778@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> TODO:
>> - show sym+offset in 'callsite' column
> 
> The way to print symbolic information for the 'callsite' column is to 
> fill in and walk the thread->DSO->symbol trees that all perf tools 
> maintain:
> 
> 	/* simplified, without error handling */
> 
> 	ip = event->ip.ip;
> 
> 	thread = threads__findnew(event->ip.pid);
> 
> 	map = thread__find_map(thread, ip);
> 
> 	ip = map->map_ip(map, ip); /* map absolute RIP into DSO-relative one */
> 
> 	sym = map__find_symbol(map, ip, symbol_filter);
> 
> then sym->name is the string that can be printed out. This works in a 
> symmetric way for both kernel-space and user-space symbols. (Call-chain 
> information can be captured and displayed too.)
> 
> ( 'Alloc Ptr' symbolization is harder, but it would be useful too i 
>   think, to map it back to the slab cache name. )
> 

Thanks.

I was lazy to figure it out by myself. ;)

>> - show cross node allocation stats
> 
> I checked and we appear to have all the right events for that - the node 
> ID is being traced consistently AFAICS.
> 

Actually kmemtrace-user shows this stats, but in a wrong way.
It doesn't map cpu_nr to node.

>> - collect more useful stats?
>> - ...
> 
> Pekka, Eduard and the other slab hackers might have ideas about what 
> other stats they generally like to see to judge the health of a workload 
> (or system).
> 
> If this iteration looks good to the slab folks then i can apply it as-is 
> and we can do the other changes relative to that. It looks good to me as 
> a first step, and it's functional already.
> 

Thanks!

