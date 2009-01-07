Return-Path: <linux-kernel-owner+w=401wt.eu-S1756743AbZAGGFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743AbZAGGFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 01:05:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbZAGGFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 01:05:44 -0500
Received: from gate.crashing.org ([63.228.1.57]:50907 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbZAGGFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 01:05:43 -0500
Subject: Re: powerpc: introduce asm/swab.h
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nicolas Pitre <nico@cam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
In-Reply-To: <alpine.LFD.2.00.0901062122100.3057@localhost.localdomain>
References: <200901070400.n0740Ore002063@hera.kernel.org>
	 <1231303340.14860.61.camel@pasglop> <1231304552.14860.72.camel@pasglop>
	 <alpine.LFD.2.00.0901062108440.3057@localhost.localdomain>
	 <alpine.LFD.2.00.0901070017550.26118@xanadu.home>
	 <alpine.LFD.2.00.0901062122100.3057@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 07 Jan 2009 17:05:30 +1100
Message-Id: <1231308330.14860.78.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Ok, I committed it as a quick-fix. I'm not sure that is necessarily the 
> final one, but at least it is better than not compiling.
> 
> For example, it's kind of silly to use two __fswab32()'s with other 
> oddness if that one just falls back on __constant_swab32: maybe we'd want 
> to make sure that we'd use ___constant_swab64() in that case, and only do 
> the whole __SWAB_64_THRU_32__ if we really have a __arch_swab32() 
> function.
> 
> Of course, I do hope that anybody who #defines __SWAB_64_THRU_32__ already 
> has that __arch_swab32() thing, so it's likely fine.
> 
> I also wonder whether gcc generates better code with a union than with 
> that 64-bit math...

Allright, it boots here on a powerbook, though IDE seems to be
busticated (it gets lost interrupts trying to enable DMA, though it does
fallback properly to PIO), but I think that's unrelated. I'll have a
closer look tomorrow.

Cheers,
Ben.


