Return-Path: <linux-kernel-owner+w=401wt.eu-S965322AbZLHAzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965322AbZLHAzH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 19:55:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965277AbZLHAzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 19:55:06 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63204 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S965193AbZLHAzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 19:55:05 -0500
Message-ID: <4B1DA3D0.7000002@cn.fujitsu.com>
Date: Tue, 08 Dec 2009 08:54:40 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/13] tracing: Extract duplicate ftrace_raw_init_event_foo()
References: <4B1CB14A.4080402@cn.fujitsu.com> <4B1CB15F.3000403@cn.fujitsu.com> <c62985530912070627l1ba96ce7x922ab5a2f4c93648@mail.gmail.com>
In-Reply-To: <c62985530912070627l1ba96ce7x922ab5a2f4c93648@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> 2009/12/7 Li Zefan <lizf@cn.fujitsu.com>:
> 
>> +static int ftrace_raw_init_event_##call(struct ftrace_event_call *event_call)\
>> +{                                                                      \
>> +       int id;                                                         \
>> +                                                                       \
>> +       id = register_ftrace_event(event_call->event);                  \
>> +       if (!id)                                                        \
>> +               return -ENODEV;                                         \
>> +       event_call->id = id;                                            \
>> +       INIT_LIST_HEAD(&event_call->fields);                            \
>> +       return 0;                                                       \
>>  }
> 
> 
> This function doesn't vary anymore in this form.
> May be can we define a generic one in trace_event.c and only reference
> this one?
> 

Ah, you're right. I should have noticed this.

I'll make a patch to do this later on.

> Or even better, may be can we drop this callback field and statically call this
> code when we intialize an event. IIRC, the syscall raw_init_event has the
> same callback, may be it's even the same for kprobes events (I can't
> check right now).

I'll check it.

