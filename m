Return-Path: <linux-kernel-owner+w=401wt.eu-S1754786AbZGPJbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbZGPJbA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 05:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754525AbZGPJa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 05:30:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61988 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753621AbZGPJa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 05:30:59 -0400
Message-ID: <4A5EF2F7.3090706@cn.fujitsu.com>
Date: Thu, 16 Jul 2009 17:29:27 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] tracing/function: fix the return value of ftrace_trace_onoff_callback()
References: <4A5D5B12.2050802@cn.fujitsu.com> <20090715142814.GA6184@nowhere>
In-Reply-To: <20090715142814.GA6184@nowhere>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> ftrace_trace_onoff_callback() will return error even if we do the
>> right operation, for example:
>>
>> # echo _spin_*:traceon:10 > set_ftrace_filter
>> -bash: echo: write error: Invalid argument
>> # cat set_ftrace_filter
>> #### all functions enabled ####
>> _spin_trylock_bh:traceon:count=10
>> _spin_unlock_irq:traceon:count=10
>> _spin_unlock_bh:traceon:count=10
>> _spin_lock_irq:traceon:count=10
>> _spin_unlock:traceon:count=10
>> _spin_trylock:traceon:count=10
>> _spin_unlock_irqrestore:traceon:count=10
>> _spin_lock_irqsave:traceon:count=10
>> _spin_lock_bh:traceon:count=10
>> _spin_lock:traceon:count=10
>>
>> We want to set _spin_*:traceon:10 to set_ftrace_filter, it complain
>> with "Invalid argument", but the operation is successful.
>> So, this patch fix it.
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> 
> Looks good, thanks.
> 
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> 

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

