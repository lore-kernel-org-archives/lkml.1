Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbYAONkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbYAONkK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 08:40:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750860AbYAONj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 08:39:58 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34667 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbYAONj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 08:39:57 -0500
Date: Tue, 15 Jan 2008 14:39:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Huang, Ying" <ying.huang@intel.com>, venkatesh.pallipadi@intel.com,
       akpm@linux-foundation.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 0/3] i386 boot: replace boot_ioremap with enhanced
	bt_ioremap
Message-ID: <20080115133942.GI7025@elte.hu>
References: <1200375902.3505.29.camel@caritas-dev.intel.com> <20080115084417.GA16449@elte.hu> <1200390535.3505.62.camel@caritas-dev.intel.com> <478CAC70.80309@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478CAC70.80309@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> I did a quick scan over the patchset (not quite awake yet, so I may 
> very well have missed something), but it looks like EFI (again!) is 
> the only user of ioremapping before paging_init().  This makes me 
> wonder if that code can't be restructured so that isn't necessary.

i think that in general making access to unmapped memory a bit easier is 
generally a good robustness idea as ACPI could be impacted by it as 
well.

Fundamentally, paging_init() has obvious dependency on "figuring out the 
memory setup" of the box, and "figuring out the memory setup" means 
interpreting various data structures passed in by the BIOS - some of 
which might be in not yet mapped areas or iommu areas (if we have to do 
some early quirk). So having a robust implementation of ioremap_early() 
sounds like a definitive plus.

	Ingo
