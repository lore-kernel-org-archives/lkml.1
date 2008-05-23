Return-Path: <linux-kernel-owner+w=401wt.eu-S1756687AbYEWQmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbYEWQmb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 12:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750983AbYEWQmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 12:42:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58545 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752124AbYEWQmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 12:42:23 -0400
Date: Fri, 23 May 2008 09:42:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arjan van de Ven <arjan@linux.intel.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Top 10 bugs/warnings for the week of March 23rd, 2008
In-Reply-To: <4836EE8C.1010200@linux.intel.com>
Message-ID: <alpine.LFD.1.10.0805230927200.3081@woody.linux-foundation.org>
References: <4836EE8C.1010200@linux.intel.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 23 May 2008, Arjan van de Ven wrote:
>
> Per file statistics
> [I'd love to borrow Linus' gitstat stuff for this to get a nicer presentation
> of the per file/directory data]

The algorithm is very simple. Just sort your filenames alphabetically, and 
then you can do it with a simple 40-line recursive function and a trivial 
data structure. See the git sources, diff.c: gather_dirstat().

Or just do "git show 7df7c019c2a46672c12a11a45600cdc698e03029" in git to 
show the commit that introduces --dirstat. 

(In fact, much of the dirstat code is the thing that turns it into 
percentages, so it has some setup code that first calculates the total 
number of changes, and the printout code spends effort in generating the 
percentage (well, permille) and not showing insignificant stuff - whether 
you'd want/need that for this is debatable)

> Rank 1: __register_sysctl_paths
> 	Reported 1260 times (2491 total reports)
> 	[tainted] Duplicate /proc registration. Bug in the madwifi driver
> 	(Occasionally seen in the parport driver)
> 	This oops was last seen in version 2.6.25.4, and first seen in 2.6.25-rc3.
> 	More info:
> http://www.kerneloops.org/searchweek.php?search=__register_sysctl_paths

Btw, can you try to call these warnings, not oopses? It's not an oops, and 
it's not even reported as an oops in the overviews on the top-level things 
on the web-site, so your scripts do know it's not an oops - but then in 
this summary and in the "detailed information" reports it's called an oops 
again.

It's a WARN_ON, and yeah, while they can be bad, it's still different 
from an actual oops.

			Linus
