Return-Path: <linux-kernel-owner+w=401wt.eu-S1756511AbYAOJyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511AbYAOJyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 04:54:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbYAOJyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 04:54:15 -0500
Received: from mga01.intel.com ([192.55.52.88]:55390 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753255AbYAOJyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 04:54:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,286,1196668800"; 
   d="scan'208";a="502253520"
Subject: Re: [PATCH -mm 0/3] i386 boot: replace boot_ioremap with enhanced
	bt_ioremap
From: "Huang, Ying" <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>, venkatesh.pallipadi@intel.com
Cc: akpm@linux-foundation.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20080115084417.GA16449@elte.hu>
References: <1200375902.3505.29.camel@caritas-dev.intel.com>
	 <20080115084417.GA16449@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 15 Jan 2008 17:48:55 +0800
Message-Id: <1200390535.3505.62.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 15 Jan 2008 09:48:41.0408 (UTC) FILETIME=[CF726400:01C8575B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-01-15 at 09:44 +0100, Ingo Molnar wrote:
> * Huang, Ying <ying.huang@intel.com> wrote:
> 
> > This patchset replaces boot_ioremap with a enhanced version of 
> > bt_ioremap and renames the bt_ioremap to early_ioremap. This reduces 
> > 12k from .init.data segment and increases the size of memory that can 
> > be re-mapped before paging_init to 64k.
> 
> in latest x86.git#mm there's an early_ioremap() introduced as part of 
> the PAT series - available on both 32-bit and 64-bit. Could you take a 
> look at it and use that if it's OK for your purposes?

After checking the early_ioremap() implementation in
arch/x86/kernel/setup_32.c, I found that it is a duplication of
bt_ioremap() implementation in arch/x86/mm/ioremap_32.c. Both
implementations use set_fixmap(), so they can be used only after
paging_init().

The early_ioremap implementation provided in this patchset works as
follow:

- Enhances bt_ioremap, make it usable before paging_init() via a
dedicated PTE page.
- Rename bt_ioremap to early_ioremap

So I think maybe we should replace the early_ioremap() implementation in
PAT series with that of this series.

Best Regards,
Huang Ying

