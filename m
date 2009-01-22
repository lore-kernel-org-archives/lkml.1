Return-Path: <linux-kernel-owner+w=401wt.eu-S1758166AbZAVV77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166AbZAVV77 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 16:59:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755492AbZAVV7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 16:59:49 -0500
Received: from mga11.intel.com ([192.55.52.93]:27499 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537AbZAVV7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 16:59:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,308,1231142400"; 
   d="scan'208";a="424746259"
Date: Thu, 22 Jan 2009 13:59:47 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG] Page table corruption from commit 9542ada803198e6eba29d3289abb39ea82047b92.
Message-ID: <20090122215947.GH28352@linux-os.sc.intel.com>
References: <49780D3D.5030406@suse.com> <20090122083149.GB7438@elte.hu> <4978E3D6.1090903@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4978E3D6.1090903@suse.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 01:23:34PM -0800, Jeff Mahoney wrote:
> Ingo Molnar wrote:
> > Could you try the current -tip tree please?
> > 
> >   http://people.redhat.com/mingo/tip.git/README
> > 
> > There's a number of fixes in there that i think will fix your crash. In 
> > particular:
> > 
> >   9597134: x86: fix PTE corruption issue while mapping RAM using /dev/mem
> 
> Yep. That change fixed the corruption, but I still get the other
> warning. It originates with mainline commit
> 5899329b19100c0b82dc78e9b21ed8b920c9ffb3.

> WARNING: at arch/x86/mm/pat.c:637 reserve_pfn_range+0x5b/0x26d()

We are aware of this warning issue. We will soon have a fix for this.
For now, this is benign (essentially mmap of /dev/mem is doing
the reserve_memtype() twice, one through phys_mem_access_prot_allowed()
and reserve_pfn_range(). We are planning to remove this double
reserve, which should fix the warning).


> I get another warning at
> the bisect site, but it seems secondary. It doesn't occur in tip, though.
> 
> WARNING: at arch/x86/mm/pageattr.c:560 __change_page_attr_set_clr+0x10b/0xc0c() 
> CPA: called for zero pte. vaddr = ffff8800f7ff0000 cpa->vaddr = ffff8800f7ff0000

This one is fixed in tip by commit a1e46212a410793d575718818e81ddc442a65283
	x86: fix page attribute corruption with cpa()

thanks,
suresh
