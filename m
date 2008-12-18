Return-Path: <linux-kernel-owner+w=401wt.eu-S1754054AbYLRWXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbYLRWXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 17:23:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbYLRWXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 17:23:43 -0500
Received: from mga02.intel.com ([134.134.136.20]:63509 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131AbYLRWXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 17:23:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,245,1228118400"; 
   d="scan'208";a="475211290"
Date: Thu, 18 Dec 2008 14:23:41 -0800
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Nick Piggin <npiggin@suse.de>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "hugh@veritas.com" <hugh@veritas.com>,
       "arjan@infradead.org" <arjan@infradead.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "jeremy@goop.org" <jeremy@goop.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: [patch 3/7] x86 PAT: hooks in generic vm code to help archs to track pfnmap regions - v3
Message-ID: <20081218222340.GC3331@linux-os.sc.intel.com>
References: <20081218194126.963894000@intel.com> <20081218194617.408164000@intel.com> <20081218213557.GF10681@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081218213557.GF10681@wotan.suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2008 at 01:35:57PM -0800, Nick Piggin wrote:
> On Thu, Dec 18, 2008 at 11:41:29AM -0800, venkatesh.pallipadi@intel.com wrote:
> > Introduce generic hooks in remap_pfn_range and vm_insert_pfn and
> > corresponding copy and free routines with reserve and free tracking.
> 
> These should be inline so that they can be folded out (I'm sure gcc
> with -Os and "optimize" inlining will do something stupid here).
> Also, the normal way to add such arch hooks is to put the default
> into asm-generic and have other archs include it... that would be
> nicer than sticking it into mm/memory.c wouldn't it?

I did check that these calls were optimized by gcc when there is no arch
specific definitions. But, as you pointed out, it should be cleaner to put this
in asm-generic, though I may have to touch more files.

> Sigh, fork/exit paths slow down yet again. But oh well. Maybe can
> you add some branch hints?

OK. Will add branch hints for these..

Thanks,
Venki

