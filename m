Return-Path: <linux-kernel-owner+w=401wt.eu-S1755774AbZLCJbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774AbZLCJbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 04:31:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754398AbZLCJbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 04:31:10 -0500
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:49616 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbZLCJbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 04:31:08 -0500
Message-ID: <4B17855F.601@linux.vnet.ibm.com>
Date: Thu, 03 Dec 2009 10:31:11 +0100
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Holger.Wolf@de.ibm.com, epasch@de.ibm.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: Missing recalculation of scheduler tunables in case of cpu hot
 add/remove
References: <4B0EA88E.3030205@linux.vnet.ibm.com> <1259252382.31676.207.camel@laptop> <4B0EAC06.3010407@linux.vnet.ibm.com> <1259252892.31676.220.camel@laptop> <4B0EAD7B.90601@linux.vnet.ibm.com> <1259253950.31676.249.camel@laptop> <20091203091206.GA1478@ucw.cz>
In-Reply-To: <20091203091206.GA1478@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
>
>   
>>>>>> Aside from that, we probably should put an upper limit in place, as I
>>>>>> guess large cpu count machines get silly large values
>>>>>>       
>>>>>>             
>>>>> I agree to that, but in the code is already an upper limit of 
>>>>> 200.000.000 - well we might discuss if that is too low/high.
>>>>>     
>>>>>           
>>>> Yeah, I think we should cap it around the 8-16 CPUs.
>>>>
>>>>   
>>>>         
>>> ok for me, driven by that finding I think I have to measure different 
>>> kind of scalings anyway, but as usually that takes some time :-/
>>> At least too time much for the discussion & solution of that bug I guess.
>>>
>>> The question for now is what we do on cpu hot add/remove?
>>> Would hooking somewhere in kernel/cpu.c be the right approach - I'm not 
>>> quite sure about my own suggestion yet :-).
>>>       
>> Something like the below might work I suppose, just needs a cleanup and
>> such.
>>     
>
> I see a rather fundamental problem: what if user wants to override
> those values, and wants them stay that way
Yep a fundamental problem, but fortunately solved already ;-)

See the series "[PATCH 0/3] fix rescaling of scheduler tunables v2" 
posted after this discussion.
That is exactly what patch #2 is about.
Giving users the choice to either set things constant (scaling=none) or 
dynamic (log or linear) as it is done boot time.

As I considered it a bug to miss the updates, the current patch 
initializes it with scaling=log to let runtime and boot behave the same way.
I could do an update to better keep interfaces which would initialize it 
with "scaling=none" to reflect by default the behavior of the current 
code that is missing scaling completely.
Comments welcome

-- 

Grüsse / regards, Christian Ehrhardt
IBM Linux Technology Center, Open Virtualization 

