Return-Path: <linux-kernel-owner+w=401wt.eu-S1761680AbYAQWr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761680AbYAQWr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:47:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759915AbYAQWhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:37:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35317 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760110AbYAQWgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:36:55 -0500
Date: Thu, 17 Jan 2008 23:35:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann3 <andreas.herrmann3@amd.com>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>, ak@muc.de,
       ebiederm@xmission.com, rdreier@cisco.com, torvalds@linux-foundation.org,
       gregkh@suse.de, airlied@skynet.ie, davej@redhat.com, tglx@linutronix.de,
       hpa@zytor.com, akpm@linux-foundation.org, arjan@infradead.org,
       jesse.barnes@intel.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: Re: [patch 0/4] x86: PAT followup - Incremental changes and bug
	fixes
Message-ID: <20080117223551.GA23543@elte.hu>
References: <20080116023955.597433000@intel.com> <20080116185748.GA11244@alberich.amd.com> <20080116203328.GA17869@linux-os.sc.intel.com> <20080117191211.GA12631@alberich.amd.com> <20080117203600.GB27778@elte.hu> <20080117210301.GC12631@alberich.amd.com> <20080117211308.GA7858@elte.hu> <20080117214228.GD12631@alberich.amd.com> <20080117222634.GG12631@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080117222634.GG12631@alberich.amd.com>
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


* Andreas Herrmann3 <andreas.herrmann3@amd.com> wrote:

> > I'll check this asap
> 
> So, now that I've avoided this tiny NULL-pointer-dereference, the 
> system boots fine as well with your (slightly modified) patch. See 
> dmesg attached.

for now i applied your ioremap_uncached() patch and removed my patch.

my patch might work if the MTRR marks that area UC. Does it on your 
system?

if the MTRRs (as set up by the BIOS) keep it at WB, then the ACPI 
ioremap() is already unsafe: the mmio area that happens to be there 
might be prefetched by the CPU.

	Ingo
