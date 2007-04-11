Return-Path: <linux-kernel-owner+w=401wt.eu-S1751877AbXDKJwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbXDKJwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 05:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751905AbXDKJwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 05:52:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36207 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877AbXDKJwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 05:52:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: 2.6.21-rc5: swsusp: Not enough free memory
Date: Wed, 11 Apr 2007 11:55:51 +0200
User-Agent: KMail/1.9.5
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux-pm@lists.osdl.org, pavel@suse.cz
References: <460B6E4B.3060004@gmail.com> <200704092220.10039.rjw@sisk.pl> <461C8FF4.80202@gmail.com>
In-Reply-To: <461C8FF4.80202@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704111155.52455.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 11 April 2007 09:36, Jiri Slaby wrote:
> Rafael J. Wysocki napsal(a):
> > On Monday, 9 April 2007 22:07, Jiri Slaby wrote:
> >> Rafael J. Wysocki napsal(a):
> >>> Thanks for testing.
> >> [...]
> >>> --- linux-2.6.21-rc5.orig/kernel/power/swsusp.c
> >>> +++ linux-2.6.21-rc5/kernel/power/swsusp.c
> >>> @@ -229,13 +229,13 @@ int swsusp_shrink_memory(void)
> >>>  		size += highmem_size;
> >>>  		for_each_zone (zone)
> >>>  			if (populated_zone(zone)) {
> >>> +				tmp += snapshot_additional_pages(zone);
> >>>  				if (is_highmem(zone)) {
> >>>  					highmem_size -=
> >>>  					zone_page_state(zone, NR_FREE_PAGES);
> >>>  				} else {
> >>>  					tmp -= zone_page_state(zone, NR_FREE_PAGES);
> >>>  					tmp += zone->lowmem_reserve[ZONE_NORMAL];
> >>> -					tmp += snapshot_additional_pages(zone);
> >> I have bad news for you :(. I thought I had unpatched kernel, but it happens
> >> in -rc6 too.
> > 
> > I guess you mean you're still seeing the 'not enough memory to suspend'
> > problem?
> 
> Yes:
> Disabling non-boot CPUs ...
> kvm: disabling virtualization on CPU1
> Breaking affinity for irq 9
> CPU 1 is now offline
> SMP alternatives: switching to UP code
> CPU1 is down
> swsusp: critical section:
> swsusp: Need to copy 158309 pages
> swsusp: Not enough free memory
> Error -12 suspending
> Enabling non-boot CPUs ...
> SMP alternatives: switching to SMP code
> Booting processor 1/2 APIC 0x1
> Initializing CPU#1

How reproducible is it?  I'm going to try to reproduce it on one of my boxes.

> >> Next, when this occurs, kernel CPU1 is not brought up and next suspend hangs
> >> on "Suspending consoles".
> > 
> > Hm, there probably is a bug in an error path.  Do you use the built in swsusp
> > or s2disk?
> 
> built-in. It happens only sometimes, here, as you can see, CPU1 was
> successfully brought up.

Sigh.  Then probably there's a problem with the CPU hotplugging and it'll be
hard to find, I'm afraid.

Greetings,
Rafael
