Return-Path: <linux-kernel-owner+w=401wt.eu-S1754561AbZGUBsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbZGUBsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 21:48:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbZGUBsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 21:48:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55422 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754290AbZGUBsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 21:48:10 -0400
Message-ID: <4A651DF2.3060403@cn.fujitsu.com>
Date: Tue, 21 Jul 2009 09:46:26 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Tom Zanussi <tzanussi@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] tracing/filters: Improve subsystem filter
References: <4A63D485.7030703@cn.fujitsu.com> <alpine.DEB.2.00.0907201207390.7595@gandalf.stny.rr.com> <alpine.DEB.2.00.0907201230320.7595@gandalf.stny.rr.com> <4A651907.1090805@cn.fujitsu.com> <alpine.DEB.2.00.0907202131390.11494@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0907202131390.11494@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Proposal 2:
>>
>>   # cat filter
>>   irq_handler_entry: irq == 5
>>   irq_handler_exit: none
>>   softirq_entry: vec == 1
>>   softirq_exit: vec == 2
> 
> I like proposal 2, it is very intuitive.
> 

Me too.

>> Which do you think is better? Or do you have some better idea?
>>
>> And in the failure case:
>>
>>   # echo 'irq == not_num' > filter
>>   bash: echo: write error: Invalid argument
>>
>> 1:
>>   # cat filter
>>   (still shows filters in each event like above)
>>
>> or shows error message (the current behavior)
> 
> No need to show error messages of failed filter modifications in the 
> "filter" file.
> 
>> 2:
>>   # cat filter
>>   irq == not_num
>>   ^
>>   parse_error: Couldn't find or set field in one of a subsystem's events
> 
> This looks good, BUT, it is too much. If you want to implement an error 
> message like the above, it should probably be a "pr_info()" thing.
> 

Yeah, I think it's too much too, but that's exactly what we have.
And I posted a patch to remove those error messages, but Tom and
Frederic didn't seem to like it:

	http://lkml.org/lkml/2009/6/17/89
