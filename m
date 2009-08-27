Return-Path: <linux-kernel-owner+w=401wt.eu-S1753016AbZH0VAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbZH0VAm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 17:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbZH0VAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 17:00:40 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:60262 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbZH0VAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 17:00:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cdgok3uu3/LSX/9XFFCahPqf+S1SZt1mRa+whT11+JSf9QJHZmge1kTO/+/9S+E66R
         c5sRe7eNrhRNa6mBmowNEz7v5yEjtcLAys0fezBs22lZaOCPfRjx5csPIHSY4AB1T4nk
         jUzILHgo72dHd9VAvB3lCt1a9upjifbvQljIU=
Message-ID: <4A96F428.3060806@gmail.com>
Date: Thu, 27 Aug 2009 14:01:28 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009031304)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #14012] latest git fried my x86_64 imac
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera>	<200908262306.38464.rjw@sisk.pl>	<4A96CA0A.90405@gmail.com>	<200908272145.01901.rjw@sisk.pl> <20090827134756.53359c08.randy.dunlap@oracle.com>
In-Reply-To: <20090827134756.53359c08.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Thu, 27 Aug 2009 21:45:01 +0200 Rafael J. Wysocki wrote:
>
>    
>> On Thursday 27 August 2009, Justin P. Mattock wrote:
>>      
>>> Rafael J. Wysocki wrote:
>>>        
>>>> On Wednesday 26 August 2009, Justin P. Mattock wrote:
>>>>
>>>>          
>>>>> Rafael J. Wysocki wrote:
>>>>>
>>>>>            
>>>>>> This message has been generated automatically as a part of a report
>>>>>> of recent regressions.
>>>>>>
>>>>>> The following bug entry is on the current list of known regressions
>>>>>> from 2.6.30.  Please verify if it still should be listed and let me know
>>>>>> (either way).
>>>>>>
>>>>>>
>>>>>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14012
>>>>>> Subject		: latest git fried my x86_64 imac
>>>>>> Submitter	: Justin P. Mattock<justinmattock@gmail.com>
>>>>>> Date		: 2009-08-13 07:20 (13 days old)
>>>>>> References	: http://marc.info/?l=linux-kernel&m=125014080427090&w=4
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>>              
>>>>> if I revert this commit:
>>>>> af6af30c0fcd77e621638e53ef8b176bca8bd3b4
>>>>> I can get a normal bootup.
>>>>>
>>>>>            
>>>> Hm, that's
>>>>
>>>> commit af6af30c0fcd77e621638e53ef8b176bca8bd3b4
>>>> Author: Peter Zijlstra<peterz@infradead.org>
>>>> Date:   Wed Aug 5 20:41:04 2009 +0200
>>>>
>>>>       ftrace: Fix perf-tracepoint OOPS
>>>>
>>>> I wonder what happens if you compile out ftrace?
>>>>
>>>>
>>>>          
>>>>> As for this  bug, it seems I'm the only
>>>>> hitting this. The system is a fresh LFS build
>>>>> x86_64.
>>>>> In regards to keeping this open
>>>>> not sure, I don't have a problem with closing this
>>>>> and taking the blame as something I did during my build
>>>>> of the system, then if this becomes more frequent
>>>>> then open a new bug.
>>>>>
>>>>>            
>>>> OK, I'll close it for now.
>>>>
>>>> Thanks,
>>>> Rafael
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>>
>>>>
>>>>          
>>> o.k. I tried disabling all of ftrace in the kernel,
>>> unfortunately the only one left
>>> is HAVE_FTRACE_SYSCALLS
>>> which seems to be selected by x86.
>>> seems the system still sticks
>>> without reverting perf-tracepoint oops.
>>>        
>> That's kind of strange.  Can you attach the .config, please?
>>      
>
> That's what arch/x86/Kconfig does:
>
> ### Arch settings
> config X86
> 	def_bool y
> ...
> 	select HAVE_FTRACE_SYSCALLS
>
> It just means that the $arch has that capability, not that it is enabled.
>
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>
>    
Alright(see how much of newbie I am),
then disabling ftrace(if its safe to say)
still doesn't resolve the issue
for me then.

best bet, in my honest opinion
is to hold off on anything, until
"if any", other reports start showing up in this manner.
if in the future there is no such reports then it's
probably safe to say I did something wrong.
Then if there is issues later in time by anybody,
then we have an idea of where/what might be the causing this.


Justin P. Mattock

