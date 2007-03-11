Return-Path: <linux-kernel-owner+w=401wt.eu-S1751889AbXCKUby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbXCKUby (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 16:31:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751674AbXCKUby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 16:31:54 -0400
Received: from www17.your-server.de ([213.133.104.17]:4797 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbXCKUby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 16:31:54 -0400
Message-ID: <45F46660.4010102@m3y3r.de>
Date: Sun, 11 Mar 2007 21:28:16 +0100
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Milan Broz <mbroz@redhat.com>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: SwSusp to disk doesn't work - Try 2
References: <45F44599.3060508@m3y3r.de> <200703112038.52375.rjw@sisk.pl> <45F46530.8050005@redhat.com> <200703112132.32753.rjw@sisk.pl>
In-Reply-To: <200703112132.32753.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki schrieb:
> On Sunday, 11 March 2007 21:23, Milan Broz wrote:
>   
>> Rafael J. Wysocki:
>>     
>>> Ah, NO_HZ.  Thomas Gleixner's address added to the Cc list.
>>>
>>>       
>>>> short printk trace 
>>>>
>>>> enable_nonboot_cpus
>>>>  _cpu_up
>>>>   raw_notifier_callchain (CPU_UP_PREPARE)
>>>>     ...
>>>>     update_sched_domains
>>>>      detach_destroy_domains
>>>>        [waits here] --> synchronize_sched (==synchronize_rcu)
>>>>         
>>> Well, I think the call to wait_for_completion() does not return, probably
>>> because the task supposed to complete the completion is frozen at this
>>> point.  Can you please try to confirm that it gets stuck on
>>> wait_for_completion() in synchronize_rcu()?
>>>       
>> Yes, it's in wait_for_completion() in synchronize_rcu().
>> As noted in some previous mail, it will wake up after
>> event - key press etc.
>>
>> Patch in http://lkml.org/lkml/2007/3/7/255 solves different problem.
>> I added it to my quilt and applied anyway -> no change.
>>     
>
> Does the problem go away if NO_HZ is unset?
>   

i tried to boot with nohz=off, but the problem did persist.

