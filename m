Return-Path: <linux-kernel-owner+w=401wt.eu-S1754735AbYIESvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735AbYIESvr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 14:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbYIESvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 14:51:36 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41647 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbYIESvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 14:51:36 -0400
Date: Fri, 5 Sep 2008 20:54:55 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, Gary Hade <garyhade@us.ibm.com>,
       linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, Mel Gorman <mel@csn.ul.ie>,
       Chris McDermott <lcm@us.ibm.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] [RESEND] x86_64: add memory hotremove config option
Message-ID: <20080905185455.GY18288@one.firstfloor.org>
References: <20080905172132.GA11692@us.ibm.com> <87ej3yv588.fsf@basil.nowhere.org> <1220639514.25932.28.camel@badari-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220639514.25932.28.camel@badari-desktop>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> At this time we are interested on node remove (on x86_64). 
> It doesn't really work well at this time - 

That's a quite euphemistic way to put it.

> due to some of the structures

That means you can never put any slab data on specific nodes.
And all the kernel subsystems on that node will not ever get local
memory.  How are you going to solve that?  And if you disallow
kernel allocations in so large memory areas you get many of the highmem
issues that plagued 32bit back in the 64bit kernel.

There are lots of other issues. It's quite questionable if this
whole exercise makes sense at all.

> (BTW, on ppc64 this works fine - since we are interested mostly in
> removing *some* sections of memory to give it back to hypervisor - 
> not entire node removal).

Ok for hypervisors you can do it reasonably easy on x86 too, but it's likely
that some hypercall interface is better than going through
sysfs. 

-Andi
