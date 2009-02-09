Return-Path: <linux-kernel-owner+w=401wt.eu-S1755809AbZBIPTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809AbZBIPTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 10:19:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754633AbZBIPTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 10:19:07 -0500
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:51517 "EHLO
	QMTA09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754620AbZBIPTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 10:19:05 -0500
Message-ID: <49904988.50408@xyzw.org>
Date: Mon, 09 Feb 2009 07:19:36 -0800
From: Brian Rogers <brian@xyzw.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Engelhardt <jengelh@medozas.de>, Ingo Molnar <mingo@elte.hu>,
       Nathanael Hoyle <nhoyle@hoyletech.com>, stable <stable@kernel.org>
Subject: Re: [stable] scheduler nice 19 versus 'idle' behavior / static	low-priority
 scheduling
References: <1233294584.28741.2.camel@localhost> <alpine.LSU.2.00.0901300710200.999@fbirervta.pbzchgretzou.qr> <1233297635.17301.11.camel@localhost> <alpine.LSU.2.00.0901300818580.28427@fbirervta.pbzchgretzou.qr> <1233302349.17301.27.camel@localhost> <1233302861.6061.14.camel@marge.simson.net> <49837B32.3010206@xyzw.org> <1233380284.5636.5.camel@marge.simson.net> <1233392893.5863.25.camel@marge.simson.net> <20090202235714.GE32075@kroah.com>
In-Reply-To: <20090202235714.GE32075@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Sat, Jan 31, 2009 at 10:08:13AM +0100, Mike Galbraith wrote:
>   
>> On Sat, 2009-01-31 at 06:38 +0100, Mike Galbraith wrote:
>>     
>>> On Fri, 2009-01-30 at 14:12 -0800, Brian Rogers wrote:
>>>       
>>>> Mike Galbraith wrote:
>>>>         
>>>>> On Fri, 2009-01-30 at 02:59 -0500, Nathanael Hoyle wrote:
>>>>>   
>>>>>           
>>>>>> I am running foldingathome under it at the moment, and it seems to be
>>>>>> improving the situation somewhat, but I still need/want to test with
>>>>>> Mike's referenced patches.
>>>>>>     
>>>>>>             
>>>>> You will most definitely encounter evilness running SCHED_IDLE tasks in
>>>>> a kernel without the SCHED_IDLE fixes.
>>>>>   
>>>>>           
>>>> Speaking of SCHED_IDLE fixes, is 
>>>> 6bc912b71b6f33b041cfde93ca3f019cbaa852bc going to be put into the next 
>>>> stable 2.6.28 release? Without it on 2.6.28.2, I can still produce 
>>>> minutes-long freezes with BOINC or other idle processes.
>>>>
>>>> With the above commit on top of 2.6.28.2 and also 
>>>> cce7ade803699463ecc62a065ca522004f7ccb3d, the problem is solved, though 
>>>> I assume cce7ad isn't actually required to fix that, and I can test that 
>>>> if desired.
>>>>         
>>> I think they both should go to stable, but dunno if they're headed that
>>> direction or not.
>>>
>>> One way to find out, CCs added.
>>>       
>> For those who may want to run SCHED_IDLE tasks in .27, I've integrated
>> and lightly tested the fixes required to do so.  One additional commit
>> was needed to get SCHED_IDLE vs nice 19 working right, namely f9c0b09.
>> Without that, SCHED_IDLE tasks received more CPU than nice 19 tasks.
>>
>> Since .27 is in long-term maintenance, I'd integrate into stable, but
>> that's not my decision.  Anyone who applies the below to their stable
>> kernel gets to keep all the pieces should something break ;-)
>>     
>
> I'm going to hold off and not do this, as it seems too risky.
>
> But thanks for the pointers, perhaps someone else will want to do this
> for their distro kernels if they have problems with this.
>   

Is this statement meant to apply to both 2.6.27 and 2.6.28, or just 2.6.27?

