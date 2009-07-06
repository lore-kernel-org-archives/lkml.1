Return-Path: <linux-kernel-owner+w=401wt.eu-S1755576AbZGFMHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbZGFMHS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 08:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbZGFMHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 08:07:08 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:60721 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358AbZGFMHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 08:07:07 -0400
Message-ID: <4A51E8EA.1050009@petalogix.com>
Date: Mon, 06 Jul 2009 14:07:06 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
       LTP <ltp-list@lists.sourceforge.net>,
       John Williams <john.williams@petalogix.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Grant Likely <grant.likely@secretlab.ca>, subrata@linux.vnet.ibm.com
Subject: Re: mmap syscall problem
References: <4A4DFB77.1080700@petalogix.com> <200907031702.52612.arnd@arndb.de> <4A519A70.50801@petalogix.com> <200907061005.36094.arnd@arndb.de>
In-Reply-To: <200907061005.36094.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Monday 06 July 2009, Michal Simek wrote:
>   
>>> Does this happen on microblaze-mmu or microblaze-nommu, or both?
>>> The mmap code for the two is very different.
>>>   
>>>       
>> For MMU code.
>>     
>
> Could this be a cache-aliasing problem? If your cache is 'virtually-indexed'
> (most architectures are 'physically-indexed'), the kernel may have written
> into different parts of the D-cache than what the user space is reading
> from. If you have a write-through cache, that can explain why you only
> see the stale data at the beginning of the page -- the cache controller
> is still busy writing back the data when you start reading it from
> DRAM through the cache alias.
>   
I don't think so because we run that test on Microblaze without caches
and test failed too.
I think that this is sufficient test to tell that the problem is not
relate with caches.

Michal

> If this is your problem, then you need to implement flush_dcache_page()
> and other functions that maintain cache consistency. See
> Documentation/cachetlb.txt and http://www.linuxjournal.com/article/7105
>
> 	Arnd <><
>   


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663

