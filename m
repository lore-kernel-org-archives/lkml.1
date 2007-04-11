Return-Path: <linux-kernel-owner+w=401wt.eu-S1750964AbXDKHg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750964AbXDKHg5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 03:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750977AbXDKHg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 03:36:57 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:60736 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbXDKHg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 03:36:56 -0400
Message-ID: <461C8FF4.80202@gmail.com>
Date: Wed, 11 Apr 2007 09:36:20 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux-pm@lists.osdl.org, pavel@suse.cz
Subject: Re: 2.6.21-rc5: swsusp: Not enough free memory
References: <460B6E4B.3060004@gmail.com> <200704031250.07307.rjw@sisk.pl> <461A9D12.1060106@gmail.com> <200704092220.10039.rjw@sisk.pl>
In-Reply-To: <200704092220.10039.rjw@sisk.pl>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Muni-Spam-TestIP: 147.251.48.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Wed, 11 Apr 2007 09:36:21 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki napsal(a):
> On Monday, 9 April 2007 22:07, Jiri Slaby wrote:
>> Rafael J. Wysocki napsal(a):
>>> Thanks for testing.
>> [...]
>>> --- linux-2.6.21-rc5.orig/kernel/power/swsusp.c
>>> +++ linux-2.6.21-rc5/kernel/power/swsusp.c
>>> @@ -229,13 +229,13 @@ int swsusp_shrink_memory(void)
>>>  		size += highmem_size;
>>>  		for_each_zone (zone)
>>>  			if (populated_zone(zone)) {
>>> +				tmp += snapshot_additional_pages(zone);
>>>  				if (is_highmem(zone)) {
>>>  					highmem_size -=
>>>  					zone_page_state(zone, NR_FREE_PAGES);
>>>  				} else {
>>>  					tmp -= zone_page_state(zone, NR_FREE_PAGES);
>>>  					tmp += zone->lowmem_reserve[ZONE_NORMAL];
>>> -					tmp += snapshot_additional_pages(zone);
>> I have bad news for you :(. I thought I had unpatched kernel, but it happens
>> in -rc6 too.
> 
> I guess you mean you're still seeing the 'not enough memory to suspend'
> problem?

Yes:
Disabling non-boot CPUs ...
kvm: disabling virtualization on CPU1
Breaking affinity for irq 9
CPU 1 is now offline
SMP alternatives: switching to UP code
CPU1 is down
swsusp: critical section:
swsusp: Need to copy 158309 pages
swsusp: Not enough free memory
Error -12 suspending
Enabling non-boot CPUs ...
SMP alternatives: switching to SMP code
Booting processor 1/2 APIC 0x1
Initializing CPU#1

>> Next, when this occurs, kernel CPU1 is not brought up and next suspend hangs
>> on "Suspending consoles".
> 
> Hm, there probably is a bug in an error path.  Do you use the built in swsusp
> or s2disk?

built-in. It happens only sometimes, here, as you can see, CPU1 was
successfully brought up.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
 B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E

Hnus <hnus@fi.muni.cz> is an alias for /dev/null

