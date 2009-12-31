Return-Path: <linux-kernel-owner+w=401wt.eu-S1752279AbZLaAq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbZLaAq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 19:46:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbZLaAq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 19:46:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:49758 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbZLaAq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 19:46:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,478,1257148800"; 
   d="scan'208";a="583223082"
Subject: Re: ACPI warning from alloc_pages_nodemask on boot (2.6.33
 regression)
From: Zhang Rui <rui.zhang@intel.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
       Len Brown <lenb@kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <20091230100519.5a72d82c@nehalam>
References: <20091229094202.25818e9b@nehalam>
	 <alpine.LFD.2.00.0912291435070.14938@localhost.localdomain>
	 <2f11576a0912292221r7ba59e9dw431c7b43b578a04@mail.gmail.com>
	 <1262187344.7135.230.camel@laptop>  <20091230100519.5a72d82c@nehalam>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 31 Dec 2009 08:47:37 +0800
Message-ID: <1262220457.12263.1403.camel@rzhang1-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-31 at 02:05 +0800, Stephen Hemminger wrote:
> On Wed, 30 Dec 2009 16:35:44 +0100
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Wed, 2009-12-30 at 15:21 +0900, KOSAKI Motohiro wrote:
> > > >> [    1.630020] ------------[ cut here ]------------
> > > >> [    1.630026] WARNING: at mm/page_alloc.c:1812 __alloc_pages_nodemask+0x617/0x730()
> > > >
> > > >        if (order >= MAX_ORDER) {
> > > >                WARN_ON_ONCE(!(gfp_mask & __GFP_NOWARN));
> > > >                return NULL;
> > > >        }
> > > >
> > > > I don't know what the mm alloc code is complaining about here.
> > 
> > > >> [    1.630028] Hardware name: System Product Name
> > > >> [    1.630029] Modules linked in:
> > > >> [    1.630032] Pid: 1, comm: swapper Not tainted 2.6.33-rc2 #4
> > > >> [    1.630034] Call Trace:
> > 
> > > >> [    1.630064]  [<ffffffff812cae3e>] acpi_os_allocate+0x25/0x27 
> > 
> > Right, so ACPI is trying to allocate something larger than 2^MAX_ORDER
> > pages, which on x86 computes to 4K * 2^11 = 8M.
> > 
> > That's not going to work.
> > 
> > Did this machine properly boot before? I seem to remember people working
> > on moving away from bootmem and getting th page/slab stuff up and
> > running sooner, it might be fallout from that...
> > 
> 
> Yes, and it still boots now.
> 
we have rootcaused the problem.
please refer to http://bugzilla.kernel.org/show_bug.cgi?id=14954

thanks,
rui

