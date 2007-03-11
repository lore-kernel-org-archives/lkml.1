Return-Path: <linux-kernel-owner+w=401wt.eu-S934004AbXCKTEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934004AbXCKTEn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 15:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934005AbXCKTEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 15:04:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934004AbXCKTEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 15:04:42 -0400
Message-ID: <45F452A2.2050009@redhat.com>
Date: Sun, 11 Mar 2007 20:04:02 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Thomas Meyer <thomas@m3y3r.de>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: SwSusp to disk doesn't work - Try 2
References: <45F44599.3060508@m3y3r.de> <200703111926.20183.rjw@sisk.pl>
In-Reply-To: <200703111926.20183.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki napsal(a):
> On Sunday, 11 March 2007 19:08, Thomas Meyer wrote:
>> Suspend to disk doesn't work on my laptop.
>>
>> The suspend seems to hang while enabling the non-boot cpus again.
>>
>> with platform = "test" and state = "disk" i get this:

>> Enabling non-boot CPUs ...
...
> 
> Could you please put some printk()s in kernel/cpu.c:_cpu_up() to see where
> it gets stuck?  I bet one of the notifiers goes to sleep (cpufreq, maybe).

Hi,
I see the same problem - 2.6.21-rc3 with NO_HZ set (tickless), 
short printk trace 

enable_nonboot_cpus
 _cpu_up
  raw_notifier_callchain (CPU_UP_PREPARE)
    ...
    update_sched_domains
     detach_destroy_domains
       [waits here] --> synchronize_sched (==synchronize_rcu)


Milan


