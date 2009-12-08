Return-Path: <linux-kernel-owner+w=401wt.eu-S965319AbZLHBBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965319AbZLHBBI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 20:01:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965235AbZLHBBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 20:01:07 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53936 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S965227AbZLHBBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 20:01:06 -0500
Message-ID: <4B1DA53E.4080004@cn.fujitsu.com>
Date: Tue, 08 Dec 2009 09:00:46 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/13] tracing: Move a printk out of	ftrace_raw_reg_event_foo()
References: <4B1CB14A.4080402@cn.fujitsu.com> <4B1CB183.7040202@cn.fujitsu.com> <20091207213228.GG5049@nowhere>
In-Reply-To: <20091207213228.GG5049@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>  	case 1:
>>  		if (!call->enabled) {
>> +			if (ret) {
>> +				pr_info("event trace: Could not enable event "
>> +					"%s\n", call->name);
>> +				break;
>> +			}
>>  			call->enabled = 1;
>>  			tracing_start_cmdline_record();
>> -			call->regfunc(call);
>> +			ret = call->regfunc(call);
> 
> Heh, I'm pretty sure I will never see this warning ;-)
> 

oops! I don't know how this mistake came.

