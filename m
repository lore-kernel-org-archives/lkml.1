Return-Path: <linux-kernel-owner+w=401wt.eu-S1752389AbZLAGcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbZLAGcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 01:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbZLAGcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 01:32:16 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56874 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbZLAGcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 01:32:16 -0500
Message-ID: <4B14B85E.9030404@cn.fujitsu.com>
Date: Tue, 01 Dec 2009 14:31:58 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <f.weisbecker@gmail.com>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] perf timechart: Remove open-coded event parsing code
References: <4B14B201.9030708@cn.fujitsu.com>	<4B14B21C.2040406@cn.fujitsu.com> <20091130222431.78a300e7@infradead.org>
In-Reply-To: <20091130222431.78a300e7@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Tue, 01 Dec 2009 14:05:16 +0800
> Li Zefan <lizf@cn.fujitsu.com> wrote:
>> -		size = 8;
>> +	if (!(sample_type & PERF_SAMPLE_RAW)) {
>> +		fprintf(stderr,
>> +			"No trace sample to read. Did you call perf
>> record "
>> +			"without -R?");
>> +		return -1;
>>  	}
> 
> while I like your cleanup... I am not so sure this printk makes sense
> whatsoever.... the user did not use "perf record" to get here...
> 

I followed builtin-trace.c and builtin-sched.c.

Well, if you run perf-record without -R, like:

 # ./perf record -a -R -f -e power:* -e sched:sched_wakeup -e sched:sched_switch

And then run perf-timechart, you'll run into that warning.

But sure, if we always run "perf timechart rec" before "perf timechart",
we never get there.

