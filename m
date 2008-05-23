Return-Path: <linux-kernel-owner+w=401wt.eu-S1757458AbYEWRfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458AbYEWRfc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 13:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbYEWRfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 13:35:25 -0400
Received: from mga05.intel.com ([192.55.52.89]:6416 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751280AbYEWRfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 13:35:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,531,1204531200"; 
   d="scan'208";a="568039836"
Message-ID: <4837004D.5080505@linux.intel.com>
Date: Fri, 23 May 2008 10:35:09 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Top 10 bugs/warnings for the week of March 23rd, 2008
References: <4836EE8C.1010200@linux.intel.com> <alpine.LFD.1.10.0805230927200.3081@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805230927200.3081@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Fri, 23 May 2008, Arjan van de Ven wrote:
>> Per file statistics
>> [I'd love to borrow Linus' gitstat stuff for this to get a nicer presentation
>> of the per file/directory data]
> 
> The algorithm is very simple. Just sort your filenames alphabetically, and 
> then you can do it with a simple 40-line recursive function and a trivial 
> data structure. See the git sources, diff.c: gather_dirstat().
> 
> Or just do "git show 7df7c019c2a46672c12a11a45600cdc698e03029" in git to 
> show the commit that introduces --dirstat. 
> 
> (In fact, much of the dirstat code is the thing that turns it into 
> percentages, so it has some setup code that first calculates the total 
> number of changes, and the printout code spends effort in generating the 
> percentage (well, permille) and not showing insignificant stuff - whether 
> you'd want/need that for this is debatable)

ok thanks I'll take a look at this; I might have to convert it to php (sigh ;)
> 
>> Rank 1: __register_sysctl_paths
>> 	Reported 1260 times (2491 total reports)
>> 	[tainted] Duplicate /proc registration. Bug in the madwifi driver
>> 	(Occasionally seen in the parport driver)
>> 	This oops was last seen in version 2.6.25.4, and first seen in 2.6.25-rc3.
>> 	More info:
>> http://www.kerneloops.org/searchweek.php?search=__register_sysctl_paths
> 
> Btw, can you try to call these warnings, not oopses? It's not an oops, and 
> it's not even reported as an oops in the overviews on the top-level things 
> on the web-site, so your scripts do know it's not an oops - but then in 
> this summary and in the "detailed information" reports it's called an oops 
> again.
> 
> It's a WARN_ON, and yeah, while they can be bad, it's still different 
> from an actual oops.
> 

I'll see how to do this; the complex case of "some are oopses some are warn_ons" I probably can just deal with
by prioritization.
(but I do track the "class" so the info is there in the database)
