Return-Path: <linux-kernel-owner+w=401wt.eu-S1757667AbZCYHZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667AbZCYHZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 03:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbZCYHZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 03:25:21 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56401 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbZCYHZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 03:25:20 -0400
Message-ID: <49C9DC75.9080301@cn.fujitsu.com>
Date: Wed, 25 Mar 2009 15:25:41 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] blktrace: fix original blktrace
References: <49C99BD2.9090503@cn.fujitsu.com> <20090325070726.GD27476@kernel.dk>
In-Reply-To: <20090325070726.GD27476@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Wed, Mar 25 2009, Li Zefan wrote:
>> I'm wondering what we are going to do with the original blktrace which
>> is using relay and is used via ioctl.
>>
>> The problem is currently it's totally broken. You can use ftrace to see
>> the output of blktrace, but user-space blktrace is unusable.
>>
>> With this patch, both ioctl and ftrace can be used, but of course you
>> can't use both of them at the same time.
> 
> Even if ftrace was as fast as storing huge amounts of data as blktrace,
> it's still of utmost importance that nothing is broken there. There are

agreed

> people actually USING this tracing to do real work, it's not a
> playground.
> 

and we are using blktrace to test the cgroup-based io controller

> I appreciate the efforts to unify and improve our tracing, but we must
> not be breaking blktrace along the way. Otherwise the whole thing goes

this patch fixes it.

it's broken by "blktrace: add ftrace plugin"
(c71a896154119f4ca9e89d6078f5f63ad60ef199)

@@ -131,13 +162,14 @@ static void __blk_add_trace()
- 	if (unlikely(bt->trace_state != Blktrace_running))
+ 	if (unlikely(bt->trace_state != Blktrace_running || !blk_tracer_enabled))
 		return;

> back to block/blktrace.c, period.
> 
