Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084Ab0BJFdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 00:33:35 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59876 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751154Ab0BJFde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 00:33:34 -0500
Message-ID: <4B72453C.2090603@cn.fujitsu.com>
Date: Wed, 10 Feb 2010 13:33:48 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: Allow to remove a single function from function
 graph filter
References: <4B71072B.1030405@cn.fujitsu.com> <1265773753.24386.51.camel@gandalf.stny.rr.com>
In-Reply-To: <1265773753.24386.51.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>  	do_for_each_ftrace_rec(pg, rec) {
>>  
>> -		if (*idx >= FTRACE_GRAPH_MAX_FUNCS)
>> -			break;
>> -
>>  		if (rec->flags & (FTRACE_FL_FAILED | FTRACE_FL_FREE))
>>  			continue;
>>  
>>  		if (ftrace_match_record(rec, search, search_len, type)) {
>> -			/* ensure it is not already in the array */
>> +			/* if it is in the array */
>>  			exists = false;
>> -			for (i = 0; i < *idx; i++)
>> +			for (i = 0; i < *idx; i++) {
>>  				if (array[i] == rec->ip) {
>>  					exists = true;
>>  					break;
>>  				}
>> -			if (!exists)
>> -				array[(*idx)++] = rec->ip;
>> -			found = 1;
>> +			}
>> +
>> +			if (!not) {
>> +				if (!exists) {
>> +					array[(*idx)++] = rec->ip;
>> +					if (*idx >= FTRACE_GRAPH_MAX_FUNCS)
>> +						goto out;
> 
> The fail = 0 needs to be first. I just tested this and on the 32'cd
> function added, it gives a failed message but still adds the function.
> 

Will fix. Thanks!

> 
>> +				}
>> +				fail = 0;
