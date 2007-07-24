Return-Path: <linux-kernel-owner+w=401wt.eu-S933454AbXGXHRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933454AbXGXHRs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 03:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759319AbXGXHRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 03:17:40 -0400
Received: from ozlabs.org ([203.10.76.45]:58797 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759553AbXGXHRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 03:17:39 -0400
Subject: Re: [kvm-devel] [RFC 0/8]KVM: swap out guest pages
From: Rusty Russell <rusty@rustcorp.com.au>
To: Avi Kivity <avi@qumranet.com>
Cc: Shaohua Li <shaohua.li@intel.com>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <46A5A36E.8000409@qumranet.com>
References: <1185173489.2645.64.camel@sli10-conroe.sh.intel.com>
	 <46A4829C.9080104@qumranet.com>
	 <1185232218.1803.36.camel@localhost.localdomain>
	 <46A58E8B.8050507@qumranet.com>
	 <1185257474.1803.216.camel@localhost.localdomain>
	 <46A59A75.8050501@qumranet.com>
	 <1185259509.1803.237.camel@localhost.localdomain>
	 <46A5A36E.8000409@qumranet.com>
Content-Type: text/plain
Date: Tue, 24 Jul 2007 17:17:16 +1000
Message-Id: <1185261436.1803.254.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-24 at 09:59 +0300, Avi Kivity wrote:
> However, you can probably work around that by not setting an rmap for
> the kernel mappings, and instead have the guest teach the host where the
> kernel page tables live.  You'd only be left with shared libraries,
> until the kernel can share page tables for them too.

Well, I already treat kernel mappings specially (effectively I know the
guest's PAGE_OFFSET): they're kept identical in all the 4 shadows, and
need explicit guest flushing.

Whether the guest shares (non-kernel) page tables or not, I will shadow
them dumb as separate page table pages the way things stand.  So, yes,
shared libs will be my main issue.  Address space randomization means I
can't even use a heuristic such as looking for the page at the same
address in other shadows.  I'll come up with something.

Anyway, virtio what I'm *supposed* to be doing today...

Thanks,
Rusty.


