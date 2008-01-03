Return-Path: <linux-kernel-owner+w=401wt.eu-S1753092AbYACNIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092AbYACNIO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 08:08:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752739AbYACNGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 08:06:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55690 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbYACNG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 08:06:29 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] [1/20] x86: Make ptrace.h safe to include from assembler code
Date: Thu, 3 Jan 2008 13:57:13 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <20080103149.088038000@suse.de> <20080103095452.GA21003@elte.hu>
In-Reply-To: <20080103095452.GA21003@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801031357.13332.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 January 2008 10:54:52 Ingo Molnar wrote:
> 
> * Andi Kleen <ak@suse.de> wrote:
> 
> > Index: linux/include/asm-x86/ptrace-abi.h
> > ===================================================================
> > --- linux.orig/include/asm-x86/ptrace-abi.h
> > +++ linux/include/asm-x86/ptrace-abi.h
> > @@ -80,6 +80,7 @@
> >  
> >  #define PTRACE_SINGLEBLOCK	33	/* resume execution until next branch */
> >  
> > +#ifndef __ASSEMBLY__
> 
> hm, this patch misses a rationale - what assembly code includes 
> ptrace-abi.h directly or indirectly? Did you see any build breakage with 
> x86.git that requires this? (if yes then please send me the .config)

It's needed for the dwarf2 unwinder, but imho useful on its own.

-Andi


