Return-Path: <linux-kernel-owner+w=401wt.eu-S1756404AbZLNBn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404AbZLNBn6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 20:43:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbZLNBn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 20:43:58 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61399 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbZLNBn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 20:43:57 -0500
Message-ID: <4B259849.6030205@cn.fujitsu.com>
Date: Mon, 14 Dec 2009 09:43:37 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Wenji Huang <wenji.huang@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] tracing/filters: Fix MATCH_FRONT_ONLY filter	matching
References: <4B2217D0.5000308@cn.fujitsu.com> <4B221800.1050504@cn.fujitsu.com> <20091211120218.GD5244@nowhere>
In-Reply-To: <20091211120218.GD5244@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Fri, Dec 11, 2009 at 05:59:28PM +0800, Li Zefan wrote:
>> MATCH_FRONT_ONLY matching works exactly as MATCH_FULL.
>>
>> We should pass the length of the pattern to strncmp().
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>> ---
>>  kernel/trace/trace_events_filter.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
>> index c8eb1c0..bd492ce 100644
>> --- a/kernel/trace/trace_events_filter.c
>> +++ b/kernel/trace/trace_events_filter.c
>> @@ -262,7 +262,7 @@ static int regex_match_full(char *str, struct regex *r, int len)
>>  
>>  static int regex_match_front(char *str, struct regex *r, int len)
>>  {
>> -	if (strncmp(str, r->pattern, len) == 0)
>> +	if (strncmp(str, r->pattern, r->len) == 0)
>>  		return 1;
>>  	return 0;
>>  }
> 
> 
> But it was working before the fix to match full.

No, it was not working for dyn_string and static_string.
And as I explained it happened to work for ptr_string by
the mixture of 2 bugs.

> The MATCH_FULL fix is nice but it also brings a new bug that
> is fixed in this patch.
> 
