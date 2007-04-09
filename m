Return-Path: <linux-kernel-owner+w=401wt.eu-S1753549AbXDIWH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbXDIWH1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 18:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753544AbXDIWH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 18:07:27 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:59206 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539AbXDIWH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 18:07:26 -0400
Date: Mon, 9 Apr 2007 15:09:36 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       shai@scalex86.org
Subject: Re: [patch] Pad irq_desc to internode cacheline size
Message-ID: <20070409220936.GD5275@localhost.localdomain>
References: <20070409195356.GA5275@localhost.localdomain> <20070409135729.a466e9cb.akpm@linux-foundation.org> <m1ejmt1apj.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ejmt1apj.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.2.1i
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2007 at 03:47:52PM -0600, Eric W. Biederman wrote:
> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> > This will consume nearly 4k per irq won't it?  What is the upper bound
> > here, across all configs and all hardware?
> >
> > Is VSMP the only arch which has ____cacheline_internodealigned_in_smp
> > larger than ____cacheline_aligned_in_smp?
> 
> Ugh. We set internode aligned to 4k for all of x86_64.

!!! No. internode aligned is 4k only if CONFIG_X86_VSMP is chosen.  The
internode line size defaults to SMP_CACHE_BYTES for all other machine types.
Please note that an INTERNODE_CACHE_SHIFT of 12 is defined under 
#ifdef CONFIG_X86_VSMP in include/asm-x86_64/cache.h

> 
> I believe this ups our worst case memory consumption for
> the array from 1M to 32M.  Although the low end might be 2M.
> I can't recall if an irq_desc takes one cache line or two
> after we have put the cpu masks in it.
> 
> My gut feel says that what we want to do is delay this until
> we are dynamically allocating the array members.  Then we can at
> least have the chance of allocating the memory on the proper NUMA
> node, and won't need the extra NUMA alignment.

I was thinking on those lines as well.  But, until we get there, can we have
this in as stop gap?  The patch does not increase the memory footprint for
any other architecture other than vSMPowered systems.
