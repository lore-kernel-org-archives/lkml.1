Return-Path: <linux-kernel-owner+w=401wt.eu-S1755205AbYAJKu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbYAJKu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 05:50:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbYAJKuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 05:50:18 -0500
Received: from mx1.suse.de ([195.135.220.2]:55319 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882AbYAJKuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 05:50:17 -0500
Date: Thu, 10 Jan 2008 11:50:15 +0100
From: Andi Kleen <ak@suse.de>
To: Dave Airlie <airlied@gmail.com>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       suresh.b.siddha@intel.com, Arjan van de Ven <arjan@infradead.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: CPA patchset
Message-ID: <20080110105015.GP25945@bingen.suse.de>
References: <20080103424.989432000@suse.de> <20080110093126.GA360@elte.hu> <21d7e9970801100144x63b02e1bga548acd3c5bed441@mail.gmail.com> <20080110095501.GL25945@bingen.suse.de> <21d7e9970801100220p406b25d8qf523388042531855@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d7e9970801100220p406b25d8qf523388042531855@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 08:20:26PM +1000, Dave Airlie wrote:
> This is only possible as long as we know all the parts involved, for
> example on AMD we have problems with that
> over-eager prefetching so for drivers on AMD chipsets we have to do
> something else more than likely using change_page_attr.

What over eager prefetching? AFAIK AMD chips don't do any prefetching
that Intel chips don't do. In fact P4 does more aggressive speculation
than any AMD chip. 

One problem I see is that the CPU (both AMD and Intel) can follow random 
addresses even from speculative execution and then there is a window between
your CLFLUSH and eventual use where the data could be forced back
into cache behind your back. Then eventually the cache gets flushed
and overwrites the data in memory.

The only way to prevent that is to unmap or remap to uncached.

Might happen only rarely of course, but it can. We've had reports
over the years for bugs which were tracked down to such cases. Each
was a bitch to debug usually keeping people busy for a long time.

> 
> >
> > Well GARTs and those are widely used even without AGP busses.
> 
> Yes mainly we have used this scheme with Intel GARTs (also the only
> driver we have done with the new GPU system) by working closely with
> Intel engineers..

Have you discussed the case above?

Also BTW even if you can solve it for Intel GPUs there are others too
who really rely on WC/UC.

-Andi

