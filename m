Return-Path: <linux-kernel-owner+w=401wt.eu-S1752477AbYIEWeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbYIEWeH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 18:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750741AbYIEWdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 18:33:55 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51125 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbYIEWdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 18:33:54 -0400
Subject: Re: [PATCH] [RESEND] x86_64: add memory hotremove config option
From: Badari Pulavarty <pbadari@us.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Gary Hade <garyhade@us.ibm.com>, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, Mel Gorman <mel@csn.ul.ie>,
       Chris McDermott <lcm@us.ibm.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20080905185455.GY18288@one.firstfloor.org>
References: <20080905172132.GA11692@us.ibm.com>
	 <87ej3yv588.fsf@basil.nowhere.org>
	 <1220639514.25932.28.camel@badari-desktop>
	 <20080905185455.GY18288@one.firstfloor.org>
Content-Type: text/plain
Date: Fri, 05 Sep 2008 15:34:03 -0700
Message-Id: <1220654043.25932.43.camel@badari-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-09-05 at 20:54 +0200, Andi Kleen wrote:
> > At this time we are interested on node remove (on x86_64). 
> > It doesn't really work well at this time - 
> 
> That's a quite euphemistic way to put it.
> 
> > due to some of the structures
> 
> That means you can never put any slab data on specific nodes.
> And all the kernel subsystems on that node will not ever get local
> memory.  How are you going to solve that?  And if you disallow
> kernel allocations in so large memory areas you get many of the highmem
> issues that plagued 32bit back in the 64bit kernel.

You are absolutely correct. There is no easy solution - one has 
to loose performance in order to support node removal, along with
some old x86 issues :(

We were contemplating idea of limiting node removal to few
select set of nodes as a compromise - but it didn't sound right :(

> 
> There are lots of other issues. It's quite questionable if this
> whole exercise makes sense at all.

Same issues exist with ia64 and x86_64 won't be any worse off.
Gary was trying to enable the functionality so that we can atleast
test out offlining memory section easier (test page migration,
isolation code and hash out issues)

Another possible idea being considered (still lot of unknowns)
to make use offline memory section feature for power management
(*cough*).

Anyway, as you can see this patch doesn't add any code - just
enables config option for x86_64. (if you are worried about
code bloat).

> > (BTW, on ppc64 this works fine - since we are interested mostly in
> > removing *some* sections of memory to give it back to hypervisor - 
> > not entire node removal).
> 
> Ok for hypervisors you can do it reasonably easy on x86 too, but it's likely
> that some hypercall interface is better than going through
> sysfs. 

sysfs interface already exists to offline sections of memory. (same
interface as online).

The proposed patch provides easy way to find out what sections of
memory belongs to which node. (could be useful on its own).

Thanks,
Badari

