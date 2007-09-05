Return-Path: <linux-kernel-owner+w=401wt.eu-S1757902AbXIEQhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902AbXIEQhp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 12:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757040AbXIEQh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 12:37:29 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55814 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756936AbXIEQh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 12:37:28 -0400
Date: Wed, 5 Sep 2007 18:37:24 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stefan Becker <Stefan.Becker@nokia.com>
Cc: ext Andi Kleen <andi@firstfloor.org>,
       ext Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [pre-2.6.23 REGRESSION] 2.6.23-rc3-git1 crash/stuck on VIA CN700 system
Message-ID: <20070905163724.GC31880@one.firstfloor.org>
References: <46C9D148.5080505@nokia.com> <p734pibbbex.fsf@bingen.suse.de> <46DDA366.8090806@nokia.com> <20070905102525.GB31880@one.firstfloor.org> <46DECDC9.9050407@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46DECDC9.9050407@nokia.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> flags		: fpu vme de pse tsc msr pae mce cx8 apic mtrr pge cmov pat 
> clflush acpi mmx fxsr sse sse2 tm up pni est tm2 rng rng_en ace ace_en 

Hmm, I can't really see anything wrong. This means the original
version of the patch you found had a few problems, but they
were all fixed later and only applied with CONFIG_PARAVIRT enabled anyways.

As a stab in the dark since the CPU has clflush can you please 
comment out the  

  if (cpu_has_clflush)
                asm("clflush (%0) " :: "r" (addr) : "memory");

statement in arch/i386/kernel/alternative.c and see if it makes a difference?
Perhaps your CPU doesn't like that (it seems to have clflush) 

If that doesn't help it might be needed to revert the patch
hunk by hunk to see which text_poke() invocation caused it.

-Andi
