Return-Path: <linux-kernel-owner+w=401wt.eu-S1753128AbZIHAwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbZIHAwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 20:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbZIHAwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 20:52:16 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59297 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752872AbZIHAwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 20:52:16 -0400
Message-ID: <4AA5AA0F.4060104@cn.fujitsu.com>
Date: Tue, 08 Sep 2009 08:49:19 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] perf_counter: Add PERF_COUNTER_IOC_SET_FILTER ioctl
References: <4AA4C04D.1050201@cn.fujitsu.com>	 <4AA4C0B3.3070300@cn.fujitsu.com> <1252341871.7959.37.camel@laptop>	 <20090907164852.GA6485@elte.hu> <1252342545.7959.42.camel@laptop>
In-Reply-To: <1252342545.7959.42.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2009-09-07 at 18:48 +0200, Ingo Molnar wrote:
>> * Peter Zijlstra <peterz@infradead.org> wrote:
>>
>>> On Mon, 2009-09-07 at 16:13 +0800, Li Zefan wrote:
>>>> Allow to set profile filter via ioctl.
>>> Hrm,.. not at all sure about this.. what are the ABI implications?
>> I think the ABI should be fine if it's always a sub-set of C syntax. 
>> That would be C expressions initially. Hm?
> 
> Right, so I've no clue what filter expressions look like, and the
> changelog doesn't help us at all. It doesn't mention its a well
> considered decision to henceforth freeze the expression syntax.
> 
> Of course, since filters so far only work with tracepoint things, and
> since you can only come by tracepoint things through debugfs, and since
> anything debugfs is basically a free-for-all ABI-less world, we might be
> good, but then this is a very ill-defined ioctl() indeed.
> 
> So please, consider this well -- there might not be a second chance.
> 

Ok, the expressions are:

  1. S = opr1 op opr2	(op: ==, !=, <, <=, >, >=.
			 opr1 should be a field in the format file)
  2. E = S1 op S2	(op: ||, &&)
  3. E = E1 op E2	(op: ||, &&)
  4. () can be used

I don't the syntax will be changed, but we may extend it, like
adding not ! operator. Like, for a func ptr, besides "func==0xccee4400",
we may want to allow "func==foo". Those extentions are ok for the
ABI, right?

