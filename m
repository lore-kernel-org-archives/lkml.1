Return-Path: <linux-kernel-owner+w=401wt.eu-S1753357AbZHaJII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbZHaJII (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 05:08:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbZHaJIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 05:08:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50055 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbZHaJIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 05:08:06 -0400
Message-ID: <4A9B92A0.7020009@cn.fujitsu.com>
Date: Mon, 31 Aug 2009 17:06:40 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/filters: Defer pred allocation
References: <4A9B8EA5.6020700@cn.fujitsu.com> <20090831085908.GA656@elte.hu>
In-Reply-To: <20090831085908.GA656@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>> init_preds() allocates about 5392 bytes of memory (on x86_32) for
>> a TRACE_EVENT. With my config, at system boot total memory occupied
>> is:
>>
>> 	5392 * (642 + 15) == 3459KB
>>
>> 642 == cat available_events | wc -l
>> 15 == number of dirs in events/ftrace
>>
>> That's quite a lot, so we'd better defer memory allocation util
>> it's needed, that's when filter is used.
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> Applied, thanks!
> 
>> tracing/kprobe needs rebase after this patch..
> 
> You mean with many probes registered it has a lot of memory 

I think so, if filter is used.

> footprint? Instead of a rebase a merge of tracing/core into 
> tracing/kprobes would be less intrusive.
> 

Yeah, I meant this patch conflicts with some patches in
tracing/kprobe. :)

