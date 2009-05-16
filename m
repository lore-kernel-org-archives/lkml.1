Return-Path: <linux-kernel-owner+w=401wt.eu-S1756775AbZEPTLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775AbZEPTLa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 15:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbZEPTLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 15:11:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:41325 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753456AbZEPTLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 15:11:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,205,1241420400"; 
   d="scan'208";a="691002598"
Subject: Re: [GIT PATCH] x86,percpu: fix pageattr handling with remap
 allocator
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: suresh.b.siddha@intel.com
To: Tejun Heo <tj@kernel.org>
Cc: "JBeulich@novell.com" <JBeulich@novell.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel-owner@vger.kernel.org" 
	<linux-kernel-owner@vger.kernel.org>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4A0ED8D8.2010303@kernel.org>
References: <1242305390-21958-1-git-send-email-tj@kernel.org>
	 <1242436626.27006.8623.camel@localhost.localdomain>
	 <4A0ED8D8.2010303@kernel.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Sat, 16 May 2009 12:09:24 -0700
Message-Id: <1242500964.27006.8636.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-05-16 at 08:16 -0700, Tejun Heo wrote:
> Hello, Suresh.
> 
> Suresh Siddha wrote:
> > Tejun, Can you please educate me why we need to map this first
> > percpu chunk (which is pre-allocated during boot and is physically
> > contiguous) into vmalloc area?
> 
> To make areas for each cpu congruent such that the address offset of a
> percpu symbol for CPU N is always the same from the address for CPU 0.

But for the first percpu chunk, isn't it the case that the physical
address allocations for a particular cpu is contiguous (as you are using
one bootmem allocation for whole PMD_SIZE for any given cpu)? So both
the kernel direct mapping aswell as the vmalloc mappings are contiguous
for the first chunk, on any given cpu. Right?

> > Perhaps even for the other dynamically allocated secondary chunks?
> > (as far as I can see, all the chunk allocations seems to be
> > physically contiguous and later mapped into vmalloc area)..
> > 
> > That should simplify these things quite a bit(atleast for first
> > percpu chunk).  I am missing something obvious I guess.
> 
> Hmm... Sorry I don't really follow.  Can you please elaborate the
> question?

For the first percpu chunk, we can use the kernel direct mapping and
avoid the vmalloc mapping of PMD_SIZE. And avoid the vmap address
aliasing problem (wrt to free pages that we have given back to -mm) that
we are trying to avoid with this patchset (as the existing cpa code
already takes care of the kernel direct mappings).

thanks,
suresh

