Return-Path: <linux-kernel-owner+w=401wt.eu-S1755452AbYCMRAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbYCMRAg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 13:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbYCMRA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 13:00:28 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:39302 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbYCMRA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 13:00:27 -0400
Date: Thu, 13 Mar 2008 16:57:37 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       virtualization@lists.osdl.org, akpm@linux-foundation.org,
       nickpiggin@yahoo.com.au, zach@vmware.com, frankeh@watson.ibm.com,
       rusty@rustcorp.com.au, jeremy@goop.org, andrea@qumranet.com,
       clameter@sgi.com, a.p.zijlstra@chello.nl
Subject: Re: [patch 0/6] Guest page hinting version 6.
In-Reply-To: <20080312132132.520833247@de.ibm.com>
Message-ID: <Pine.LNX.4.64.0803131627450.17244@blonde.site>
References: <20080312132132.520833247@de.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008, Martin Schwidefsky wrote:
> Greetings,
> I've dedusted the guest page hinting patches and ported them to todays
> upstream git tree. There is one reject if applied to 2.6.24-rc5-mm1 but
> that is easy to fix. The code stills works as expected on my test system.
> 
> Our z/VM performance team recently published a report on guest page
> hinting vs. the ballooner approach on SLES10 for a farm of web servers.
> The code on SLES10 differs a bit from the upstream variant but the
> performance results should be still valid.  You will find the report
> here:
> 
>   http://www.vm.ibm.com/perf/reports/zvm/html/530cmm.html
> 
> (the VMRM-CMM the web page speaks about is the balloon approach,
>  CMMA is the guest page hinting).
> 
> Both approaches to the memory overcommit problem show comparable benefits
> for this workload, with an advantage for guest page hinting for large
> number of guests. For other workloads your mileage may vary.
> 
> The main benefit for guest page hinting vs. the ballooner is that there
> is no need for a monitor that keeps track of the memory usage of all the
> guests, a complex algorithm that calculates the working set sizes and for
> the calls into the guest kernel to control the size of the balloons.
> The host just does normal LRU based paging. If the host picks one of the
> pages the guest can recreate, the host can throw it away instead of writing
> it to the paging device. Simple and elegant.
> The main disadvantage is the added complexity that is introduced to the
> guests memory management code to do the page state changes and to deal
> with discard faults.
> 
> The last versions of the patches do not differ much, I consider the code
> to be stable. My question now is how to proceed with the code. I sure
> would love to see the code going upstream some day but that depends on
> the mm developers as the code adds complexity that needs to be supported.
> If the general feeling is that the advantages of this approach do not
> warrent for the added complexity this will likely be the last time you
> will hear about guest page hinting. 

Oh, that would be such a shame.  Your guest page hinting patches remind
me of that childhood thrill, when once a year the circus comes to town ;)

But seriously, I'm ashamed to see my name in the Cc list: it would
be very unfair if your patches never made it in, just because I've
failed to find the time to wrap my own puny brain around them.

It's very encouraging to see Jeremy and Rusty weighing in.  I hope
Zach will too, and I've added Andrea: their support would count a lot.
You have Nick on the list, good, I've added Christoph and Peter
(if you do resend, linux-mm might prove more useful than linux-kernel).

With support from rival virtualizers,
I do think you've a good chance of getting in.

Hugh
