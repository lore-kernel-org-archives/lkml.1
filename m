Return-Path: <linux-kernel-owner+w=401wt.eu-S1752513AbZIAAwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513AbZIAAwM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 20:52:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbZIAAwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 20:52:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59462 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751556AbZIAAwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 20:52:11 -0400
Message-ID: <4A9C6FEB.40202@cn.fujitsu.com>
Date: Tue, 01 Sep 2009 08:50:51 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/filters: Defer pred allocation
References: <4A9B8EA5.6020700@cn.fujitsu.com> <20090831174107.GB6048@nowhere>
In-Reply-To: <20090831174107.GB6048@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> @@ -1094,6 +1118,10 @@ int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
>>  
>>  	mutex_lock(&event_mutex);
>>  
>> +	err = init_preds(call);
>> +	if (err)
>> +		goto out_unlock;
> 
> 
> 
> Hmm, but what happens if the filter already has its preds initialized
> by a previous filter?
> 
> The first thing that init_preds() does is:
> 
> filter = call->filter = kzalloc(sizeof(*filter), GFP_KERNEL);
> 
> That looks like a memory leak.
> 

Oops! I thought I had added a check in it.

Thanks.

