Return-Path: <linux-kernel-owner+w=401wt.eu-S1753299AbZHXTTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbZHXTTE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 15:19:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753104AbZHXTTC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 15:19:02 -0400
Received: from mail-gx0-f205.google.com ([209.85.217.205]:59458 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbZHXTTB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 15:19:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QddDj+lVoTOVGbfEkkAUfsvOOx0DCdXw8TSQtIoW5DznrXHUsVs6H54TWo2umnEKUH
         IUtgVkPIyuDtjY2PU9CWNLflJmuNTJryQf9YWZYnOPmpEh0E7/bqKqPxmDedJP/4X3cS
         prUIZi51NL49BUjXixyqUS29pfPdUPjP37mk0=
MIME-Version: 1.0
In-Reply-To: <4A9251EB.8040805@gmail.com>
References: <4A84345D.60506@gmail.com>
	 <alpine.DEB.2.00.0908181926410.28398@gandalf.stny.rr.com>
	 <4A8B4607.6090303@gmail.com> <4A8B5113.20102@cn.fujitsu.com>
	 <4A8FA2BD.4030707@gmail.com> <4A91FDED.9050801@cn.fujitsu.com>
	 <1251093523.7538.118.camel@twins> <4A922F82.9080000@cn.fujitsu.com>
	 <1251096925.7538.121.camel@twins> <4A9251EB.8040805@gmail.com>
Date: Mon, 24 Aug 2009 12:19:02 -0700
Message-ID: <dd18b0c30908241219mdb76311t9334929f34f2c4c3@mail.gmail.com>
Subject: Re: system gets stuck in a lock during boot
From: Justin Mattock <justinmattock@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 1:40 AM, Justin P.
Mattock<justinmattock@gmail.com> wrote:
> Peter Zijlstra wrote:
>>
>> On Mon, 2009-08-24 at 14:13 +0800, Li Zefan wrote:
>>
>>>
>>> Peter Zijlstra wrote:
>>>
>>>>
>>>> On Mon, 2009-08-24 at 10:41 +0800, Li Zefan wrote:
>>>>
>>>>
>>>>>>
>>>>>> @@ -940,7 +940,7 @@ event_create_dir(struct ftrace_event_call *call,
>>>>>> struct dentr
>>>>>>                 entry = trace_create_file("enable", 0644, call->dir,
>>>>>> call,
>>>>>>                                           enable);
>>>>>>
>>>>>> -       if (call->id)
>>>>>> +       if (call->id&&  call->profile_enable)
>>>>>>
>>>>>
>>>>> We do an extra check on ->profile_enable, shouldn't cause bug..
>>>>>
>>>>>
>>>>>>
>>>>>>                 entry = trace_create_file("id", 0444, call->dir, call,
>>>>>>                                           id);
>>>>>>
>>>>>
>>>>> Any way, I don't think this commit does the right thing:
>>>>>
>>>>>   - If CONFIG_EVENT_PROFILE=y, we'll create events/<dir>/<event>/id,
>>>>>     except events/ftrace/<event>/id.
>>>>>
>>>>>   - if CONFIG_EVENT_PROFILE=n, there's no 'id' file at all!
>>>>>
>>>>> I think it's better to skip ftrace/ dir in perf tool code, instead of
>>>>> skipping creating id files in ftrace code.
>>>>>
>>>>
>>>> No, it does do the right thing. Your patch breaks things because not all
>>>> tracepoints are created through TRACE_EVENT() and will thus not have
>>>> their profile_enable/disable hooks set.
>>>>
>>>> By giving them an ID file, there is no way to distinguish good from bad
>>>> tracepoints.
>>>>
>>>>
>>>
>>> But removing the id file from events/ftrace/ might break some ftrace
>>> binary parsers?
>>>
>>> And this commit makes 'id' file disapeared with CONFIG_EVENT_PROFILE=n.
>>>
>>
>> I introduced the id file for EVENT_PROFILE, tough luck if someone else
>> relies on it.
>>
>>
>>>>
>>>> Expempting ftrace is no solid solution, suppose someone else does a
>>>> TRACE_EVENT_FORMAT() tracepoint, how would you know you could use it as
>>>> a profile event source?
>>>>
>>>>
>>>
>>> Agree.
>>>
>>>
>>>>
>>>> The id files really must stay conditional.
>>>>
>>>>
>>>
>>> I don't think it's a good idea to connect it with perfcounter
>>> this way. Wouldn't adding a 'profilable' file more intuitive?
>>>
>>
>> its called: id ;-)
>>
>>
>
> After looking at ps auxZ
> I see xterm as root instead of my user name.
> This gives me enough evidence to throw
> this system away and start over.
>
> sorry for the waste of time.
>
> Justin P. Mattock
>

O.K. I feel better, deleted
my system, and threw in a minimal built system
with only the bare essentials to boot.
(just to make sure things are correct).

unfortunately after building rc6 I'm still hitting
this. really am not sure why this is happening.

-- 
Justin P. Mattock
