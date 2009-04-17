Return-Path: <linux-kernel-owner+w=401wt.eu-S1762361AbZDQSM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762361AbZDQSM1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 14:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932356AbZDQSLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 14:11:51 -0400
Received: from gw.goop.org ([64.81.55.164]:54209 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932339AbZDQSLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 14:11:50 -0400
Message-ID: <49E8C663.5010206@goop.org>
Date: Fri, 17 Apr 2009 11:11:47 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: mathieu.desnoyers@polymtl.ca, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 2/4] x86/pvops: target CREATE_TRACE_POINTS to particular
 subsystems
References: <1239950139-1119-1-git-send-email-jeremy@goop.org> <1239950139-1119-3-git-send-email-jeremy@goop.org> <alpine.DEB.2.00.0904171149100.14919@gandalf.stny.rr.com> <49E8AAC8.5080004@goop.org> <alpine.DEB.2.00.0904171231270.14919@gandalf.stny.rr.com> <49E8B2EB.8030108@goop.org> <alpine.DEB.2.00.0904171251490.14919@gandalf.stny.rr.com> <49E8B907.9000109@goop.org> <alpine.DEB.2.00.0904171330190.14919@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0904171330190.14919@gandalf.stny.rr.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Fri, 17 Apr 2009, Jeremy Fitzhardinge wrote:
>
>   
>> Steven Rostedt wrote:
>>     
>>> On Fri, 17 Apr 2009, Jeremy Fitzhardinge wrote:
>>>
>>>   
>>>       
>>>> Steven Rostedt wrote:
>>>>     
>>>>         
>>>>> Ah yes! It needs to be:
>>>>>
>>>>> #ifdef CONFIG_IRQ_TRACE_POINTS
>>>>> #undef CONFIG_IRQ_TRACE_POINTS
>>>>> #include <trace/define_trace.h>
>>>>> #endif
>>>>>
>>>>> Otherwise we get into the recursion again.
>>>>>         
>>>>>           
>>>> We should probably also move the #define TRACE_SYS in there as well
>>>> (without
>>>> the #undef), as it should only have one definition at a time...
>>>>     
>>>>         
>>> Actually, I'm kind of against that. Just because as it stands, the
>>> TRACE_SYSTEM macro is up at the top, and it is easy to see.
>>>   
>>>       
>> Yes, but it means that if you're in the middle of CREATE_FOO_TRACE_POINTS and
>> foo.h happens to include bar.h, suddenly TRACE_SUBSYSTEM becomes bar...
>>     
>
> How so?
>   

Hm, not exactly sure - now that I think of it - but it fixed things when 
I made the change.  Before I was getting kmem definitions where I was 
expecting pvops ones...

    J
