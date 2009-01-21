Return-Path: <linux-kernel-owner+w=401wt.eu-S1761932AbZAUCug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761932AbZAUCug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 21:50:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756378AbZAUCu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 21:50:27 -0500
Received: from mx1.suse.de ([195.135.220.2]:56279 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755922AbZAUCu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 21:50:26 -0500
Date: Wed, 21 Jan 2009 03:50:24 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, steiner@sgi.com
Subject: Re: [patch] x86: make UV support configurable
Message-ID: <20090121025024.GF24891@wotan.suse.de>
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

How's this?

---
 drivers/misc/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/misc/Kconfig
===================================================================
--- linux-2.6.orig/drivers/misc/Kconfig
+++ linux-2.6/drivers/misc/Kconfig
@@ -170,7 +170,7 @@ config ENCLOSURE_SERVICES
 config SGI_XP
 	tristate "Support communication between SGI SSIs"
 	depends on NET
-	depends on (IA64_GENERIC || IA64_SGI_SN2 || IA64_SGI_UV || X86_64) && SMP
+	depends on (IA64_GENERIC || IA64_SGI_SN2 || IA64_SGI_UV || X86_UV) && SMP
 	select IA64_UNCACHED_ALLOCATOR if IA64_GENERIC || IA64_SGI_SN2
 	select GENERIC_ALLOCATOR if IA64_GENERIC || IA64_SGI_SN2
 	select SGI_GRU if (IA64_GENERIC || IA64_SGI_UV || X86_64) && SMP
@@ -197,7 +197,7 @@ config HP_ILO
 
 config SGI_GRU
 	tristate "SGI GRU driver"
-	depends on (X86_64 || IA64_SGI_UV || IA64_GENERIC) && SMP
+	depends on (X86_UV || IA64_SGI_UV || IA64_GENERIC) && SMP
 	default n
 	select MMU_NOTIFIER
 	---help---
