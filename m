Return-Path: <linux-kernel-owner+w=401wt.eu-S932923Ab0AGDPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932923Ab0AGDPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 22:15:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756302Ab0AGDPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 22:15:44 -0500
Received: from mga11.intel.com ([192.55.52.93]:40389 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755919Ab0AGDPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 22:15:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,233,1262592000"; 
   d="scan'208";a="529152881"
Subject: Re: [RFC][PATCH] vmalloc: simplify vread()/vwrite()
From: Huang Ying <ying.huang@intel.com>
To: "Wu, Fengguang" <fengguang.wu@intel.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       Andi Kleen <andi@firstfloor.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Christoph Lameter <cl@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100107025054.GA11252@localhost>
References: <20100107012458.GA9073@localhost>
	 <20100107103825.239ffcf9.kamezawa.hiroyu@jp.fujitsu.com>
	 <20100107025054.GA11252@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jan 2010 11:15:41 +0800
Message-ID: <1262834141.17852.23.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-07 at 10:50 +0800, Wu, Fengguang wrote:
> On Thu, Jan 07, 2010 at 09:38:25AM +0800, KAMEZAWA Hiroyuki wrote:
> > On Thu, 7 Jan 2010 09:24:59 +0800
> > Wu Fengguang <fengguang.wu@intel.com> wrote:
> > 
> > > vread()/vwrite() is only called from kcore/kmem to access one page at
> > > a time.  So the logic can be vastly simplified.
> > > 
> > I recommend you to rename the function because safety of function is
> > changed and you can show what callers are influenced.
> 
> OK.
>  
> > > The changes are:
> > > - remove the vmlist walk and rely solely on vmalloc_to_page()
> > > - replace the VM_IOREMAP check with (page && page_is_ram(pfn))
> > > 
> > > The VM_IOREMAP check is introduced in commit d0107eb07320b for per-cpu
> > > alloc. Kame, would you double check if this change is OK for that
> > > purpose?
> > > 
> > I think VM_IOREMAP is for avoiding access to device configuration area and
> > unexpected breakage in device. Then, VM_IOREMAP are should be skipped by
> > the caller. (My patch _just_ moves the avoidance of callers to vread()/vwrite())
> 
> "device configuration area" is not RAM, so testing of RAM would be
> able to skip them?
> 
> > 
> > > The page_is_ram() check is necessary because kmap_atomic() is not
> > > designed to work with non-RAM pages.
> > > 
> > I think page_is_ram() is not a complete method...on x86, it just check
> > e820's memory range. checking VM_IOREMAP is better, I think.
> 
> (double check) Not complete or not safe?
> 
> EFI seems to not update e820 table by default.  Ying, do you know why?

In EFI system, E820 table is constructed from EFI memory map in boot
loader, so I think you can rely on E820 table.

Best Regards,
Huang Ying


