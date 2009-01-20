Return-Path: <linux-kernel-owner+w=401wt.eu-S1762295AbZATQHD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762295AbZATQHD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 11:07:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759705AbZATQGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 11:06:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39819 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759050AbZATQGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 11:06:43 -0500
Date: Tue, 20 Jan 2009 17:06:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86: make UV support configurable
Message-ID: <20090120160637.GB32650@elte.hu>
References: <20090120033604.GF16304@wotan.suse.de> <20090120142733.GD10224@elte.hu> <20090120155000.GA27200@elte.hu> <20090120155334.GB225848@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090120155334.GB225848@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Jack Steiner <steiner@sgi.com> wrote:

> On Tue, Jan 20, 2009 at 04:50:00PM +0100, Ingo Molnar wrote:
> > 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > * Nick Piggin <npiggin@suse.de> wrote:
> > > 
> > > > Fixed the EFI omission since the last patch. I have not changed the 
> > > > Kconfig to include (what I think are) false dependencies (which really 
> > > > frustrate me when things get badly tangled up). If people want to test 
> > > > as much stuff as possible even that is not supported by their hardware, 
> > > > we have allyesconfig/allmodconfig. I don't think UV is particularly 
> > > > special in that respect (we allow Intel, AMD, etc CPUs to be configured 
> > > > out)
> > > > 
> > > > If anything, X86_UV should *select* MAXSMP, rather than the other way 
> > > > around. That would be more logical, but even then I don't like adding 
> > > > still a false dep because one might have a small UV system, or want to 
> > > > test with different NR_CPUS.
> > > > 
> > > > Anyway, I think this patch is good as-is. If someone wants to streamline 
> > > > config options with subsequent patches, that's great. If Ingo can be 
> > > > convinced of a better arrangement, fine.
> > > 
> > > Applied to tip/x86/uv, thanks Nick!
> > 
> > hm, build failure with the attached config:
> > 
> > 
> > drivers/built-in.o: In function `gru_cpu_fault_map_id':
> > : undefined reference to `per_cpu____uv_hub_info'
> > drivers/built-in.o: In function `gru_fault':
> > : undefined reference to `per_cpu____uv_hub_info'
> > drivers/built-in.o: In function `gru_try_dropin':
> > grufault.c:(.text+0xbfc6e): undefined reference to 
> > `per_cpu____uv_hub_info'
> > grufault.c:(.text+0xc0042): undefined reference to 
> > `per_cpu____uv_hub_info'
> > [...]
> > 
> > (if possible please send a delta fix on top of your previous patch.)
> 
> The GRU driver makes sense only on UV & IA64 configurations.

that's not expressed in the Kconfig rules.

	Ingo
