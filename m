Return-Path: <linux-kernel-owner+w=401wt.eu-S1756381AbZLGGf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381AbZLGGf4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 01:35:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752706AbZLGGfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 01:35:55 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:57875 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbZLGGfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 01:35:54 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf_event: fix for processing raw event - fix
References: <4B1C7EE1.8030906@cn.fujitsu.com>
	<4B1C7F45.5080105@cn.fujitsu.com> <4B1C8CC4.4050007@cn.fujitsu.com>
	<87ein747k7.fsf@devron.myhome.or.jp>
Date: Mon, 07 Dec 2009 15:35:59 +0900
In-Reply-To: <87ein747k7.fsf@devron.myhome.or.jp> (OGAWA Hirofumi's message of
	"Mon, 07 Dec 2009 15:33:28 +0900")
Message-ID: <87aaxv47g0.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:

> Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> writes:
>
>> raw->size is not used, this patch just cleanup it
>
> Oops, I didn't notice those. Thanks.
>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
>> ---
>>  tools/perf/builtin-kmem.c  |   38 +++++++-----------
>>  tools/perf/builtin-sched.c |   94 +++++++++++++++++++------------------------
>>  2 files changed, 56 insertions(+), 76 deletions(-)
>>
>> diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
>> index f84d7a3..7551a5f 100644
>> --- a/tools/perf/builtin-kmem.c
>> +++ b/tools/perf/builtin-kmem.c
>> @@ -57,11 +57,6 @@ static struct rb_root root_caller_sorted;
>>  static unsigned long total_requested, total_allocated;
>>  static unsigned long nr_allocs, nr_cross_allocs;
>>  
>> -struct raw_event_sample {
>> -	u32 size;
>> -	char data[0];
>> -};
>> -
>>  #define PATH_SYS_NODE	"/sys/devices/system/node"
>>  
>>  static void init_cpunode_map(void)
>> @@ -201,7 +196,7 @@ static void insert_caller_stat(unsigned long call_site,
>>  	}
>>  }
>>  
>> -static void process_alloc_event(struct raw_event_sample *raw,
>> +static void process_alloc_event(void *data,
>>  				struct event *event,
>>  				int cpu,
>>  				u64 timestamp __used,
>
> How about the following patch instead of playing with unsafe "void *"?
> With this, I guess it does type check, and filed handling functions can

s/filed handling/field handling of sample raw data/

> check "size" by passing "struct sample_raw_data" instead of "void *" in
> future.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
