Return-Path: <linux-kernel-owner+w=401wt.eu-S1762747AbZEHDGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762747AbZEHDGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 23:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763810AbZEHDCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 23:02:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52138 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1763786AbZEHDCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 23:02:35 -0400
Message-ID: <4A03A100.5020308@cn.fujitsu.com>
Date: Fri, 08 May 2009 11:03:28 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] tracing/events: clean up for ftrace_set_clr_event()
References: <4A03998E.3020503@cn.fujitsu.com> <alpine.DEB.2.00.0905072248180.28378@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0905072248180.28378@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> @@ -500,30 +505,16 @@ system_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
>>  	if (ret < 0)
>>  		return ret;
>>  
>> -	switch (val) {
>> -	case 0:
>> -	case 1:
>> -		break;
>> -
>> -	default:
>> +	if (val != 0 && val != 1)
> 
> What about "if (val & ~1UL)"?
> 

I tried it just now:

   text    data     bss     dec     hex filename
   7480     104       8    7592    1da8 kernel/trace/trace_events.o.orig
   text    data     bss     dec     hex filename
   7482     104       8    7594    1daa kernel/trace/trace_events.o

It increased text size by 2 bytes, gcc did a better work. ;)

And it's not so intuitive what's the limit of val.


