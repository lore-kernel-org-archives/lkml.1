Return-Path: <linux-kernel-owner+w=401wt.eu-S1753579AbYIETxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbYIETxj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 15:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbYIETxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 15:53:30 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:56964 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbYIETx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 15:53:29 -0400
Date: Fri, 5 Sep 2008 12:53:14 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Gary Hade <garyhade@us.ibm.com>, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Badari Pulavarty <pbadari@us.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       Chris McDermott <lcm@us.ibm.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] [RESEND] x86_64: add memory hotremove config option
Message-ID: <20080905195314.GE11692@us.ibm.com>
References: <20080905172132.GA11692@us.ibm.com> <87ej3yv588.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ej3yv588.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2008 at 08:04:55PM +0200, Andi Kleen wrote:
> Gary Hade <garyhade@us.ibm.com> writes:
> >
> > Add memory hotremove config option to x86_64
> >
> > Memory hotremove functionality can currently be configured into
> > the ia64, powerpc, and s390 kernels.  This patch makes it possible
> > to configure the memory hotremove functionality into the x86_64
> > kernel as well. 
> 
> You forgot to describe how you tested it? Does it actually work.

So far, I have tested it on a 2-node IBM x460, 2-node IBM x3950, and
a 4-node IBM x3950 M2 and have been able to successfully offline and
re-online all memory sections marked as removable multiple times with
no apparent problems.

By directing the change to -mm our hope is that others will try it
on their systems and help us shake out any issues that they my find.

> And why do you want to do it it? What's the use case?

A baby step towards evental total node removal.

> 
> The general understanding was that it doesn't work very well on a real
> machine at least because it cannot be controlled how that memory maps
> to real pluggable hardware (and you cannot completely empty a node at runtime)
> and a Hypervisor would likely use different interfaces anyways.

The inability to offline all non-primary node memory sections
certainly needs to be addressed.  The pgdat removal work that
Yasunori Goto has started will hopefully continue and help resolve
this issue.  We have only just started thinking about issues related
to resources other that CPUs and memory that will need to be released
in preparation for node removal (e.g. memory and i/o resources
assigned to PCI devices on a node targeted for removal).  Much of
this is new territory for us so any suggestions that you and others
can offer will be much appreciated.

Thanks for asking.

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

