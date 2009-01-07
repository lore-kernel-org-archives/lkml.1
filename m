Return-Path: <linux-kernel-owner+w=401wt.eu-S1755514AbZAGFiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbZAGFiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 00:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbZAGFiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 00:38:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36062 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751892AbZAGFiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 00:38:02 -0500
Date: Tue, 6 Jan 2009 21:37:28 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Nicolas Pitre <nico@cam.org>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: powerpc: introduce asm/swab.h
In-Reply-To: <alpine.LFD.2.00.0901070017550.26118@xanadu.home>
Message-ID: <alpine.LFD.2.00.0901062122100.3057@localhost.localdomain>
References: <200901070400.n0740Ore002063@hera.kernel.org> <1231303340.14860.61.camel@pasglop> <1231304552.14860.72.camel@pasglop> <alpine.LFD.2.00.0901062108440.3057@localhost.localdomain> <alpine.LFD.2.00.0901070017550.26118@xanadu.home>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Jan 2009, Nicolas Pitre wrote:

> On Tue, 6 Jan 2009, Linus Torvalds wrote:
> > On Wed, 7 Jan 2009, Benjamin Herrenschmidt wrote:
> > 
> > Can you also verify that it works for you (not just compiles), just so 
> > that I can commit it?
> 
> Tested OK on ARM (using LE mode with networking, etc.)

Ok, I committed it as a quick-fix. I'm not sure that is necessarily the 
final one, but at least it is better than not compiling.

For example, it's kind of silly to use two __fswab32()'s with other 
oddness if that one just falls back on __constant_swab32: maybe we'd want 
to make sure that we'd use ___constant_swab64() in that case, and only do 
the whole __SWAB_64_THRU_32__ if we really have a __arch_swab32() 
function.

Of course, I do hope that anybody who #defines __SWAB_64_THRU_32__ already 
has that __arch_swab32() thing, so it's likely fine.

I also wonder whether gcc generates better code with a union than with 
that 64-bit math...

			Linus
