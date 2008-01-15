Return-Path: <linux-kernel-owner+w=401wt.eu-S1755504AbYAOM6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504AbYAOM6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 07:58:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750851AbYAOM6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 07:58:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53386 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbYAOM6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 07:58:34 -0500
Message-ID: <478CAC70.80309@zytor.com>
Date: Tue, 15 Jan 2008 07:52:00 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Huang, Ying" <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, venkatesh.pallipadi@intel.com,
       akpm@linux-foundation.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 0/3] i386 boot: replace boot_ioremap with enhanced
 bt_ioremap
References: <1200375902.3505.29.camel@caritas-dev.intel.com>	 <20080115084417.GA16449@elte.hu> <1200390535.3505.62.camel@caritas-dev.intel.com>
In-Reply-To: <1200390535.3505.62.camel@caritas-dev.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang, Ying wrote:
> 
> After checking the early_ioremap() implementation in
> arch/x86/kernel/setup_32.c, I found that it is a duplication of
> bt_ioremap() implementation in arch/x86/mm/ioremap_32.c. Both
> implementations use set_fixmap(), so they can be used only after
> paging_init().
> 
> The early_ioremap implementation provided in this patchset works as
> follow:
> 
> - Enhances bt_ioremap, make it usable before paging_init() via a
> dedicated PTE page.
> - Rename bt_ioremap to early_ioremap
> 
> So I think maybe we should replace the early_ioremap() implementation in
> PAT series with that of this series.
> 

I did a quick scan over the patchset (not quite awake yet, so I may very 
well have missed something), but it looks like EFI (again!) is the only 
user of ioremapping before paging_init().  This makes me wonder if that 
code can't be restructured so that isn't necessary.

	-hpa

