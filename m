Return-Path: <linux-kernel-owner+w=401wt.eu-S1757720AbZEHLQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720AbZEHLQ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 07:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762982AbZEHLPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 07:15:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64651 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758453AbZEHLPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 07:15:16 -0400
Message-ID: <4A041478.5070401@cn.fujitsu.com>
Date: Fri, 08 May 2009 19:16:08 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] tracing/events: clean up for ftrace_set_clr_event()
References: <4A03998E.3020503@cn.fujitsu.com> <20090508105013.GA6417@nowhere>
In-Reply-To: <20090508105013.GA6417@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Fri, May 08, 2009 at 10:31:42AM +0800, Li Zefan wrote:
>> Add a helper function __ftrace_set_clr_event(), and replace some
>> ftrace_set_clr_event() calls with this helper, thus we don't need any
>> kstrdup() or kmalloc().
>>
>> As a side effect, this patch fixes an issue in self tests code, which is
>> similar to the one fixed in commit d6bf81ef0f7474434c2a049e8bf3c9146a14dd96
>> ("tracing: append ":*" to internal setting of system events")
>>
>> It's a small issue and won't cause any bug in fact, but we should do things
>> right anyway.
>>
>> [ Impact: clean up ]
> 
> If this fixes an issue like you described, then it's more than a cleanup :)
> 

That issue causes no bug, and that's why I call it a cleanup.

How about (mainly stealed from commit d6bf81ef0f7474434c2a049e8bf3c9146a14dd96):

[ Impact: prevent accidental enabling of events with same name as a system in self tests ]

But it excceeds 80 char..

I sometimes feel it hard to write Impact line (one of the reason is my limit
English skill). I've explained the impact of this patch in detail, but I'm
still required to add a one-line summary. :(

> 
...
>> +		if (event && strcmp(event, call->name) != 0)
>> +			continue;
> 
> 
> Neat: You can simply use !strcmp(...)
> 

Actually it's arguable which is better, and both styles are used in kernel code.

And that 'if (!ptr)' vs 'if (ptr == NULL)'..

