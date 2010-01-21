Return-Path: <linux-kernel-owner+w=401wt.eu-S1752559Ab0AUFtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab0AUFtj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 00:49:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751736Ab0AUFti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 00:49:38 -0500
Received: from mga14.intel.com ([143.182.124.37]:25740 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871Ab0AUFti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 00:49:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="235145316"
Date: Thu, 21 Jan 2010 13:49:32 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Christoph Lameter <cl@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH 5/8] vmalloc: simplify vread()/vwrite()
Message-ID: <20100121054932.GD24236@localhost>
References: <20100113135305.013124116@intel.com> <20100113135957.833222772@intel.com> <20100114124526.GB7518@laptop> <20100118133512.GC721@localhost> <20100118142359.GA14472@laptop> <20100119013303.GA12513@localhost> <20100119112343.04f4eff5.kamezawa.hiroyu@jp.fujitsu.com> <20100121050521.GB24236@localhost> <20100121142106.c13c2bbf.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
In-Reply-To: <20100121142106.c13c2bbf.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 10:21:06PM -0700, KAMEZAWA Hiroyuki wrote:
> On Thu, 21 Jan 2010 13:05:21 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > On Mon, Jan 18, 2010 at 07:23:43PM -0700, KAMEZAWA Hiroyuki wrote:

> > I did some audit and find that
> > 
> > - set_memory_uc(), set_memory_array_uc(), set_pages_uc(),
> >   set_pages_array_uc() are called EFI code and various video drivers,
> >   all of them don't touch HIGHMEM RAM
> > 
> > - Kame: ioremap() won't allow remap of physical RAM
> > 
> > So kmap_atomic() is safe.  Let's just settle on this patch?
> > 
> I recommend you to keep check on VM_IOREMAP. That was checked far before
> I started to see Linux. Some _unknown_ driver can call get_vm_area() and
> map arbitrary pages there.

OK, I'll turn this patch into a less radical one.

Thanks,
Fengguang
