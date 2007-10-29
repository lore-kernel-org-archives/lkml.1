Return-Path: <linux-kernel-owner+w=401wt.eu-S1760421AbXJ2TD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760421AbXJ2TD0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 15:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754822AbXJ2TDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 15:03:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:58829 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496AbXJ2TDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 15:03:17 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Dave Jones <davej@redhat.com>
Subject: Re: 2.6.23 boot failures on x86-64.
Date: Mon, 29 Oct 2007 20:03:09 +0100
User-Agent: KMail/1.9.6
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Martin Ebourne <fedora@ebourne.me.uk>,
       Zou Nan hai <nanhai.zou@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20071029175014.GH7793@redhat.com> <200710291918.43869.ak@suse.de> <20071029184747.GB1650@redhat.com>
In-Reply-To: <20071029184747.GB1650@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710292003.09317.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 October 2007 19:47:47 Dave Jones wrote:
> On Mon, Oct 29, 2007 at 07:18:43PM +0100, Andi Kleen wrote:
>  > On Monday 29 October 2007 18:50:14 Dave Jones wrote:
>  > > We've had a number of people reporting that their x86-64s stopped booting
>  > > when they moved to 2.6.23.  It rebooted just after discovering the AGP bridge
>  > > as a result of the IOMMU init.
>  > 
>  > It's probably the usual "nobody tests sparsemem at all" issue.
> 
> We've been using SPARSEMEM in Fedora for a *long* time.
> So long in fact, I forget why we moved away from DISCONTIGMEM, so there's
> a significant number of users using that configuration for some time.

Supposedly you wanted a slower kernel that needs more memory? 

Ok I wasn't aware of that. I tended to get sparsemem reports usually
at least 1-2 releases after the fact, so it looked like it was undertested.

> 
>  > But if allocating bootmem >4G doesn't work on these systems
>  > most likely they have more problems anyways. It might be better
>  > to find out what goes wrong exactly.
> 
> Any ideas on what to instrument ?

See what address the bootmem_alloc_high returns; check if it overlaps
with something etc.

Fill the memory on the system and see if it can access all of its memory.

-Andi
