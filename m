Return-Path: <linux-kernel-owner+w=401wt.eu-S1755450AbYEXFIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbYEXFIE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 01:08:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbYEXFHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 01:07:52 -0400
Received: from mga10.intel.com ([192.55.52.92]:5292 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750979AbYEXFHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 01:07:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,533,1204531200"; 
   d="scan'208";a="331899115"
Message-ID: <4837A2A3.2030204@linux.intel.com>
Date: Fri, 23 May 2008 22:07:47 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Top 10 bugs/warnings for the week of March 23rd, 2008
References: <4836EE8C.1010200@linux.intel.com> <20080524001509.GG4018@sequoia.sous-sol.org>
In-Reply-To: <20080524001509.GG4018@sequoia.sous-sol.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright wrote:
> * Arjan van de Ven (arjan@linux.intel.com) wrote:
>> Rank 9: task_has_capability
>> 	Reported 34 times
>> 	[tainted] Bug in the proprietary firegl driver
         ^^^^^^^^^
>> 	Oops only shows up in tainted kernels
                               ^^^^^^^^
>> 	This oops was last seen in version 2.6.25.3, and first seen in 2.6.25.
>> 	More info: http://www.kerneloops.org/searchweek.php?search=task_has_capability
> 
> looking at first one: http://www.kerneloops.org/raw.php?rawid=13598&msgid=
> 
> OK, aside of the obvious (their problem):
> 
>   Tainted: P
>   EIP is at task_has_capability+0x48/0x76
>   Code: ... <0f> 0b 
>   	    ^^^^^^^
> 	    BUG()
> 
> This should be listed under the BUG/BUG_ON category as opposed to oops, no?

yeah it should; Linus pointed that out and I've since fixed my report generator script

> Also, I think the raw data is missing some bit.  Where is the:
> 
>   kernel BUG at...
> 
hmm it ought to be there.

> At any rate, they have a bug in their proprietary module (news at 11).
> 
> So, I don't think this should make the top ten.  Do you have a way to
> sort tainted vs non-tainted, and only produce the top ten for untainted?

yes absolutely; this is a question I'll have for the customers of the data...
do people want to see "only-tainted" in these top 10s? Right now I mark them as such
but leave them in. It's trivial for me to just leave them out instead (the info is there,
just a matter of not counting)

> 
> And one last question re: the stats.  Is there a way to tell if the 41
> times this was reported are from 41 distinct users.  Is there any unique
> cookie you receive with the raw oops report that can help filter out
> duplicates (by duplicate I mean a user w/ this proprietary driver and
> rebooting is likely to reproduce the same info on each boot).  You don't
> want to drop dups, but at least let that info the stats or something.

There is no unique per-system ID yet; I'm working with the SMOLT guys to get this added potentially.

> 
> For the record, that bug triggers:
> 
>   printk(KERN_ERR "SELinux:  out of range capability %d\n", cap);
>   BUG();
> 
> meaning they are passing in a capability that's > 63 (2.6.25 introduced
> 64 bit caps).
> 
> BTW, EAX: 00000030 (48)...that suggests their capability they passed in
> was quite large, likely an address or smth.

yeah iirc the AMD graphics driver gives the user process full root caps for some time...
Annoying things these non-root linux users ;)

