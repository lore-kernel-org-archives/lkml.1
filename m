Return-Path: <linux-kernel-owner+w=401wt.eu-S932696AbXCKWAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696AbXCKWAh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 18:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932875AbXCKWAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 18:00:37 -0400
Received: from www17.your-server.de ([213.133.104.17]:4138 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932696AbXCKWAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 18:00:36 -0400
Message-ID: <45F47B2D.1090403@m3y3r.de>
Date: Sun, 11 Mar 2007 22:57:01 +0100
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: tglx@linutronix.de
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Milan Broz <mbroz@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: SwSusp to disk doesn't work - Try 2
References: <45F44599.3060508@m3y3r.de> <45F46660.4010102@m3y3r.de>	 <45F46D33.1050808@redhat.com>  <200703112209.53665.rjw@sisk.pl> <1173650195.13341.11.camel@localhost.localdomain>
In-Reply-To: <1173650195.13341.11.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner schrieb:
> On Sun, 2007-03-11 at 22:09 +0100, Rafael J. Wysocki wrote:
>   
>>>>>>>>     update_sched_domains
>>>>>>>>      detach_destroy_domains
>>>>>>>>        [waits here] --> synchronize_sched (==synchronize_rcu)
>>>>>>>>         
>>>>>>>>                 
>>>>>>> Well, I think the call to wait_for_completion() does not return, probably
>>>>>>> because the task supposed to complete the completion is frozen at this
>>>>>>> point.  Can you please try to confirm that it gets stuck on
>>>>>>> wait_for_completion() in synchronize_rcu()?
>>>>>>>       
>>>>>>>               
>>>>>> Yes, it's in wait_for_completion() in synchronize_rcu().
>>>>>> As noted in some previous mail, it will wake up after
>>>>>> event - key press etc.
>>>>>>
>>>>>> Patch in http://lkml.org/lkml/2007/3/7/255 solves different problem.
>>>>>> I added it to my quilt and applied anyway -> no change.
>>>>>>     
>>>>>>             
>>>>> Does the problem go away if NO_HZ is unset?
>>>>>   
>>>>>           
>>>> i tried to boot with nohz=off, but the problem did persist.
>>>>         
>>> Hmmmm, both variants (nohz=off or recompiled kernel without NO_HZ) works for me.
>>>       
>> Definitely something strange is going on here.
>>
>> I think we need an advice from someone who knows the RCU internals.
>>     
>
> RCU synchronization depends on the timer interrupt. Which kernel version
> are you guys talking about ?
>
> 	tglx
>   

I talk about be521466feb3bb1cd89de82a2b1d080e9ebd3cb6 (2.6.21-rc3+).

The worst config is with nohz and without hrtimers: the kernel even 
doesn't come back after pressing the power key.

But i stay with without nohz and without hrtimers for now, because here 
the suspend to disk works.

