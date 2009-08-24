Return-Path: <linux-kernel-owner+w=401wt.eu-S1751546AbZHXHxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546AbZHXHxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 03:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbZHXHxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 03:53:49 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:59699 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbZHXHxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 03:53:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Ink+/jO29bjHDuFnExhewOrhgtang5ltWyS6UoJ9wF2FEe4fO5eRJ7OxQRaMsMoG7X
         +48dFyBf+sMjx2CETKo8qlpEGjpvqZa2fvYIr7tKt1nQW+YqF7EWbScWIyCsX8KXF2sY
         /UNvTj4/pGSLsJ1BbdU0ignW/QlFZ14vPis7k=
Message-ID: <4A924720.3060205@gmail.com>
Date: Mon, 24 Aug 2009 00:54:08 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009022519)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: system gets stuck in a lock during boot
References: <4A84345D.60506@gmail.com> <20090818104905.GC5231@nowhere>	 <20090818160911.GA21243@goodmis.org>	 <dd18b0c30908180924n3848d32ave258f98a5f703c38@mail.gmail.com>	 <alpine.DEB.2.00.0908181926410.28398@gandalf.stny.rr.com>	 <4A8B4607.6090303@gmail.com> <4A8B5113.20102@cn.fujitsu.com>	 <4A8FA2BD.4030707@gmail.com>  <4A91FDED.9050801@cn.fujitsu.com>	 <1251093523.7538.118.camel@twins>  <4A922F82.9080000@cn.fujitsu.com> <1251096925.7538.121.camel@twins>
In-Reply-To: <1251096925.7538.121.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2009-08-24 at 14:13 +0800, Li Zefan wrote:
>    
>> Peter Zijlstra wrote:
>>      
>>> On Mon, 2009-08-24 at 10:41 +0800, Li Zefan wrote:
>>>
>>>        
>>>>> @@ -940,7 +940,7 @@ event_create_dir(struct ftrace_event_call *call, struct dentr
>>>>>                  entry = trace_create_file("enable", 0644, call->dir, call,
>>>>>                                            enable);
>>>>>
>>>>> -       if (call->id)
>>>>> +       if (call->id&&  call->profile_enable)
>>>>>            
>>>> We do an extra check on ->profile_enable, shouldn't cause bug..
>>>>
>>>>          
>>>>>                  entry = trace_create_file("id", 0444, call->dir, call,
>>>>>                                            id);
>>>>>            
>>>> Any way, I don't think this commit does the right thing:
>>>>
>>>>    - If CONFIG_EVENT_PROFILE=y, we'll create events/<dir>/<event>/id,
>>>>      except events/ftrace/<event>/id.
>>>>
>>>>    - if CONFIG_EVENT_PROFILE=n, there's no 'id' file at all!
>>>>
>>>> I think it's better to skip ftrace/ dir in perf tool code, instead of
>>>> skipping creating id files in ftrace code.
>>>>          
>>> No, it does do the right thing. Your patch breaks things because not all
>>> tracepoints are created through TRACE_EVENT() and will thus not have
>>> their profile_enable/disable hooks set.
>>>
>>> By giving them an ID file, there is no way to distinguish good from bad
>>> tracepoints.
>>>
>>>        
>> But removing the id file from events/ftrace/ might break some ftrace
>> binary parsers?
>>
>> And this commit makes 'id' file disapeared with CONFIG_EVENT_PROFILE=n.
>>      
>
> I introduced the id file for EVENT_PROFILE, tough luck if someone else
> relies on it.
>
>    
>>> Expempting ftrace is no solid solution, suppose someone else does a
>>> TRACE_EVENT_FORMAT() tracepoint, how would you know you could use it as
>>> a profile event source?
>>>
>>>        
>> Agree.
>>
>>      
>>> The id files really must stay conditional.
>>>
>>>        
>> I don't think it's a good idea to connect it with perfcounter
>> this way. Wouldn't adding a 'profilable' file more intuitive?
>>      
>
> its called: id ;-)
>
>    
Alright, I'm going to go back to the beginning
and start my build from scratch(make sure things are legit).

Justin P. Mattock

