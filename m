Return-Path: <linux-kernel-owner+w=401wt.eu-S1761443AbZATPxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761443AbZATPxo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 10:53:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756263AbZATPxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 10:53:36 -0500
Received: from relay3.sgi.com ([192.48.171.31]:47401 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755772AbZATPxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 10:53:35 -0500
Date: Tue, 20 Jan 2009 09:53:34 -0600
From: Jack Steiner <steiner@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86: make UV support configurable
Message-ID: <20090120155334.GB225848@sgi.com>
References: <20090120033604.GF16304@wotan.suse.de> <20090120142733.GD10224@elte.hu> <20090120155000.GA27200@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090120155000.GA27200@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 04:50:00PM +0100, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > * Nick Piggin <npiggin@suse.de> wrote:
> > 
> > > Fixed the EFI omission since the last patch. I have not changed the 
> > > Kconfig to include (what I think are) false dependencies (which really 
> > > frustrate me when things get badly tangled up). If people want to test 
> > > as much stuff as possible even that is not supported by their hardware, 
> > > we have allyesconfig/allmodconfig. I don't think UV is particularly 
> > > special in that respect (we allow Intel, AMD, etc CPUs to be configured 
> > > out)
> > > 
> > > If anything, X86_UV should *select* MAXSMP, rather than the other way 
> > > around. That would be more logical, but even then I don't like adding 
> > > still a false dep because one might have a small UV system, or want to 
> > > test with different NR_CPUS.
> > > 
> > > Anyway, I think this patch is good as-is. If someone wants to streamline 
> > > config options with subsequent patches, that's great. If Ingo can be 
> > > convinced of a better arrangement, fine.
> > 
> > Applied to tip/x86/uv, thanks Nick!
> 
> hm, build failure with the attached config:
> 
> 
> drivers/built-in.o: In function `gru_cpu_fault_map_id':
> : undefined reference to `per_cpu____uv_hub_info'
> drivers/built-in.o: In function `gru_fault':
> : undefined reference to `per_cpu____uv_hub_info'
> drivers/built-in.o: In function `gru_try_dropin':
> grufault.c:(.text+0xbfc6e): undefined reference to 
> `per_cpu____uv_hub_info'
> grufault.c:(.text+0xc0042): undefined reference to 
> `per_cpu____uv_hub_info'
> [...]
> 
> (if possible please send a delta fix on top of your previous patch.)

The GRU driver makes sense only on UV & IA64 configurations.



--- jack
