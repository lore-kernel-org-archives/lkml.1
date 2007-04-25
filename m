Return-Path: <linux-kernel-owner+w=401wt.eu-S1423235AbXDYG5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423235AbXDYG5O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 02:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161625AbXDYG5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 02:57:14 -0400
Received: from ns.suse.de ([195.135.220.2]:39095 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161621AbXDYG5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 02:57:13 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Shaohua Li <shaohua.li@intel.com>
Subject: Re: [Intel IOMMU][patch 3/8] Generic hardware support for Intel IOMMU.
Date: Wed, 25 Apr 2007 08:53:35 +0200
User-Agent: KMail/1.9.6
Cc: Ashok Raj <ashok.raj@intel.com>, linux-kernel@vger.kernel.org,
       akpm@osdl.org, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com
References: <20070424060259.426374000@intel.com> <200704242127.09221.ak@suse.de> <1177463851.11073.6.camel@sli10-conroe.sh.intel.com>
In-Reply-To: <1177463851.11073.6.camel@sli10-conroe.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704250853.35666.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 A
> > It doesn't seem to enable sg merging? Since you have enough space 
> > that should work.
> We actually have a patch to do sg merge. In my test, it doesn't have any
> performance gain.

It probably depends on the IO device and how slow or fast it is at walking sg lists. 
I saw a small win (few percent gain) some years ago with MPT Fusion chips

> > A GFP_ATOMIC mempool is rather useless. mempool only works if it can block
> > for someone else freeing memory and if it can't do that it's not failsafe.
> > I'm afraid you need to revise the allocation strategy -- best would be
> > to somehow move the memory allocations outside the spinlock paths
> > and preallocate if possible.
> The problem is pci_map_single and friends usually called with interrupt
> disabled or spin locked, so we must use GFP_ATOMIC.

Yes I know, but the mempool still won't work. The design is b0rken.

-Andi
