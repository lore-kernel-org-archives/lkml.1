Return-Path: <linux-kernel-owner+w=401wt.eu-S1751591AbZLWA7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591AbZLWA7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 19:59:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751117AbZLWA7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 19:59:32 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53760 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbZLWA7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 19:59:31 -0500
Message-ID: <4B316B66.2020206@cn.fujitsu.com>
Date: Wed, 23 Dec 2009 08:59:18 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: rostedt@goodmis.org, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: Fix lockdep warning in global_clock()
References: <4B2F1543.8020300@cn.fujitsu.com>	 <20091221064356.GA2378@elte.hu>  <4B2F2588.8070501@cn.fujitsu.com>	 <1261406427.4314.155.camel@laptop>	 <1261410984.25193.8.camel@gandalf.stny.rr.com>	 <4B305680.4090304@cn.fujitsu.com> <1261470234.4937.1.camel@laptop>
In-Reply-To: <1261470234.4937.1.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Tue, 2009-12-22 at 13:17 +0800, Li Zefan wrote:
> 
>> Looking into sched_clock.c, seems the only place that can trigger lockdep
>> is the local_irq_* in cpu_clock(), though I'm not sure for architecture-
>> specific sched_clock().
> 
> But why would you want to do that? that reduces the lockdep coverage for
> no good reason, just fix up the tracer.
> 

Then the proper fix is to use local_irq_* in global_clock(), which
is what this patch does.

