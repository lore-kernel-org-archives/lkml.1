Return-Path: <linux-kernel-owner+w=401wt.eu-S964888AbXCKTTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964888AbXCKTTu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 15:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964893AbXCKTTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 15:19:50 -0400
Received: from www17.your-server.de ([213.133.104.17]:2514 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964888AbXCKTTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 15:19:49 -0400
Message-ID: <45F4557A.9010203@m3y3r.de>
Date: Sun, 11 Mar 2007 20:16:10 +0100
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Milan Broz <mbroz@redhat.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: SwSusp to disk doesn't work - Try 2
References: <45F44599.3060508@m3y3r.de> <200703111926.20183.rjw@sisk.pl> <45F452A2.2050009@redhat.com>
In-Reply-To: <45F452A2.2050009@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Milan Broz schrieb:
> Rafael J. Wysocki napsal(a):
>   
>> On Sunday, 11 March 2007 19:08, Thomas Meyer wrote:
>>     
>>> Suspend to disk doesn't work on my laptop.
>>>
>>> The suspend seems to hang while enabling the non-boot cpus again.
>>>
>>> with platform = "test" and state = "disk" i get this:
>>>       
>
>   
> Hi,
> I see the same problem - 2.6.21-rc3 with NO_HZ set (tickless), 
> short printk trace 
>
> enable_nonboot_cpus
>  _cpu_up
>   raw_notifier_callchain (CPU_UP_PREPARE)
>     ...
>     update_sched_domains
>      detach_destroy_domains
>        [waits here] --> synchronize_sched (==synchronize_rcu)
>
>   

Maybe this helps:

Mar 11 20:03:56 [kernel] PM: Removing info for No Bus:msr1
Mar 11 20:03:56 [kernel] CPU1 is down
Mar 11 20:03:56 [kernel] swsusp debug: Waiting for 5 seconds.
Mar 11 20:03:56 [kernel] Enabling non-boot CPUs ...
Mar 11 20:03:56 [kernel] _cpu_up: before notifier CPU_UP_PREPARE.
Mar 11 20:03:56 [kernel] migration_call: Hi!
Mar 11 20:03:56 [kernel] rcu_cpu_notify: Hi!
Mar 11 20:03:56 [kernel] timer_cpu_notify: Hi!
Mar 11 20:03:56 [kernel] hrtimer_cpu_notify: Hi!
Mar 11 20:03:56 [kernel] cpu_callback: Hi!
Mar 11 20:03:56 [kernel] workqueue_cpu_callback: Hi!
Mar 11 20:03:56 [kernel] topology_cpu_callback: Hi!

Guess what? Hang!

Mar 11 20:03:56 [kernel] _cpu_up: after notifier CPU_UP_PREPARE.
Mar 11 20:03:56 [kernel] SMP alternatives: switching to SMP code
Mar 11 20:03:56 [kernel] Booting processor 1/1 eip 3000
Mar 11 20:03:56 [kernel] CPU 1 irqstacks, hard=c0388000 soft=c0386000
Mar 11 20:03:56 [kernel] Initializing CPU#1


I use NO_HZ, too. Will try without it.

With kind regards
thomas


