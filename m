Return-Path: <linux-kernel-owner+w=401wt.eu-S1761966AbYD2Pxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761966AbYD2Pxt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 11:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759915AbYD2PxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 11:53:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:55334 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755102AbYD2PxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 11:53:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,723,1199692800"; 
   d="scan'208";a="558459984"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86_32: trim memory by updating e820 v3
Date: Tue, 29 Apr 2008 08:52:17 -0700
User-Agent: KMail/1.9.9
Cc: Gabriel C <nix.or.die@googlemail.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Mika Fischer <mika.fischer@zoopnet.de>, balajirrao@gmail.com,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
References: <200801192045.17291.yinghai.lu@sun.com> <200804280909.06561.jesse.barnes@intel.com> <20080429103741.GL23198@elte.hu>
In-Reply-To: <20080429103741.GL23198@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804290852.17618.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 29, 2008 3:37 am Ingo Molnar wrote:
> * Jesse Barnes <jesse.barnes@intel.com> wrote:
> > > i think we should still try to make this a non-default option
> > > because modern Xorg should not have any need to touch MTRRs. Perhaps
> > > a .config dependent on CONFIG_DANGEROUS ;-)
> >
> > Well, not quite... we're still waiting on some way of getting WC
> > semantics for sysfs PCI files.  Suresh tells me something like that is
> > queued up, but until that hits the mainline X will still need to bang
> > the MTRRs to get decent performance.
>
> yes, the patch below is queued up for an eventual v2.6.26 merge. If it
> looks fine to you, could you please ack it so that we can send it to
> Linus? I'd like to do this after some pending PAT fixes are upstream.
>
> 	Ingo
>
> ---------------->
> Subject: x86, PAT: export resource_wc in pci sysfs
> From: venkatesh.pallipadi@intel.com
> Date: Tue, 18 Mar 2008 17:00:22 -0700
>
> For the ranges with IORESOURCE_PREFETCH, export a new resource_wc interface
> in pci /sysfs along with resource (which is uncached).
>
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

I really would have preferred a new mmap flag for this like ia64 used to have, 
but Suresh and Venki tell me that a flag doesn't map very well to what some 
architectures support, so I suppose a new file is the way to go.  Should work 
fine for X's needs.

Acked-by:  Jesse Barnes <jbarnes@virtuousgeek.org>

Thanks,
Jesse
