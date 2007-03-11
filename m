Return-Path: <linux-kernel-owner+w=401wt.eu-S965083AbXCKTrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965083AbXCKTrf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 15:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965149AbXCKTrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 15:47:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40785 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965145AbXCKTrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 15:47:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Meyer <thomas@m3y3r.de>
Subject: Re: SwSusp to disk doesn't work - Try 2
Date: Sun, 11 Mar 2007 20:50:15 +0100
User-Agent: KMail/1.9.5
Cc: Milan Broz <mbroz@redhat.com>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
References: <45F44599.3060508@m3y3r.de> <45F452A2.2050009@redhat.com> <45F4557A.9010203@m3y3r.de>
In-Reply-To: <45F4557A.9010203@m3y3r.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703112050.16284.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 11 March 2007 20:16, Thomas Meyer wrote:
> Milan Broz schrieb:
> > Rafael J. Wysocki napsal(a):
> >   
> >> On Sunday, 11 March 2007 19:08, Thomas Meyer wrote:
> >>     
> >>> Suspend to disk doesn't work on my laptop.
> >>>
> >>> The suspend seems to hang while enabling the non-boot cpus again.
> >>>
> >>> with platform = "test" and state = "disk" i get this:
> >>>       
> >
> >   
> > Hi,
> > I see the same problem - 2.6.21-rc3 with NO_HZ set (tickless), 
> > short printk trace 
> >
> > enable_nonboot_cpus
> >  _cpu_up
> >   raw_notifier_callchain (CPU_UP_PREPARE)
> >     ...
> >     update_sched_domains
> >      detach_destroy_domains
> >        [waits here] --> synchronize_sched (==synchronize_rcu)
> >
> >   
> 
> Maybe this helps:
> 
> Mar 11 20:03:56 [kernel] PM: Removing info for No Bus:msr1
> Mar 11 20:03:56 [kernel] CPU1 is down
> Mar 11 20:03:56 [kernel] swsusp debug: Waiting for 5 seconds.
> Mar 11 20:03:56 [kernel] Enabling non-boot CPUs ...
> Mar 11 20:03:56 [kernel] _cpu_up: before notifier CPU_UP_PREPARE.
> Mar 11 20:03:56 [kernel] migration_call: Hi!
> Mar 11 20:03:56 [kernel] rcu_cpu_notify: Hi!
> Mar 11 20:03:56 [kernel] timer_cpu_notify: Hi!
> Mar 11 20:03:56 [kernel] hrtimer_cpu_notify: Hi!
> Mar 11 20:03:56 [kernel] cpu_callback: Hi!
> Mar 11 20:03:56 [kernel] workqueue_cpu_callback: Hi!
> Mar 11 20:03:56 [kernel] topology_cpu_callback: Hi!
> 
> Guess what? Hang!

Hm, you may be hitting the problem described in this thread:
http://lkml.org/lkml/2007/3/6/364 .

Can you please apply the patch at http://lkml.org/lkml/2007/3/7/255
and see if that helps?

Rafael
