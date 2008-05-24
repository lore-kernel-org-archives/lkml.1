Return-Path: <linux-kernel-owner+w=401wt.eu-S1759422AbYEXAQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759422AbYEXAQA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 20:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751418AbYEXAPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 20:15:50 -0400
Received: from sous-sol.org ([216.99.217.87]:55351 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416AbYEXAPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 20:15:49 -0400
Date: Fri, 23 May 2008 17:15:13 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Top 10 bugs/warnings for the week of March 23rd, 2008
Message-ID: <20080524001509.GG4018@sequoia.sous-sol.org>
References: <4836EE8C.1010200@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4836EE8C.1010200@linux.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arjan van de Ven (arjan@linux.intel.com) wrote:
> Rank 9: task_has_capability
> 	Reported 34 times
> 	[tainted] Bug in the proprietary firegl driver
> 	Oops only shows up in tainted kernels
> 	This oops was last seen in version 2.6.25.3, and first seen in 2.6.25.
> 	More info: http://www.kerneloops.org/searchweek.php?search=task_has_capability

looking at first one: http://www.kerneloops.org/raw.php?rawid=13598&msgid=

OK, aside of the obvious (their problem):

  Tainted: P
  EIP is at task_has_capability+0x48/0x76
  Code: ... <0f> 0b 
  	    ^^^^^^^
	    BUG()

This should be listed under the BUG/BUG_ON category as opposed to oops, no?
Also, I think the raw data is missing some bit.  Where is the:

  kernel BUG at...

At any rate, they have a bug in their proprietary module (news at 11).

So, I don't think this should make the top ten.  Do you have a way to
sort tainted vs non-tainted, and only produce the top ten for untainted?

And one last question re: the stats.  Is there a way to tell if the 41
times this was reported are from 41 distinct users.  Is there any unique
cookie you receive with the raw oops report that can help filter out
duplicates (by duplicate I mean a user w/ this proprietary driver and
rebooting is likely to reproduce the same info on each boot).  You don't
want to drop dups, but at least let that info the stats or something.

For the record, that bug triggers:

  printk(KERN_ERR "SELinux:  out of range capability %d\n", cap);
  BUG();

meaning they are passing in a capability that's > 63 (2.6.25 introduced
64 bit caps).

BTW, EAX: 00000030 (48)...that suggests their capability they passed in
was quite large, likely an address or smth.

"<3>SELinux:  out of range capability \n" <-- 38 chars
that leaves 10 for %d, which is > 999,999,999 ;-)

thanks,
-chris
