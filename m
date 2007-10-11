Return-Path: <linux-kernel-owner+w=401wt.eu-S1757598AbXJKJYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598AbXJKJYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 05:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756623AbXJKJYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 05:24:13 -0400
Received: from styx.suse.cz ([82.119.242.94]:45540 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756542AbXJKJYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 05:24:12 -0400
Date: Thu, 11 Oct 2007 11:23:52 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>,
       David Mosberger-Tang <davidm@hpl.hp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RESEND] i386 and x86_64: randomize brk()
In-Reply-To: <20071011011800.0c051792.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0710111119460.20620@jikos.suse.cz>
References: <Pine.LNX.4.64.0709111416390.7343@jikos.suse.cz>
 <20071011011800.0c051792.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2007, Andrew Morton wrote:

> I seem to have a different copy of this patch from the one which you 
> originally sent.  It's the one which implements arch_randomize_brk() in 
> each arch's header file.  Mayeb it wasn't cc'ed to a mailing list of 
> maybe I just lost the email, dunno.

Yes, it should the the last version of this patch, and it should also have 
gone to lkml.

> Anyway, it breaks on ia64:
[...]
> This is because ia64 takes the exceptional stupidity which is our
> elf-handling build system and adds an extra layer of stupidity on top of
> it.  Look:
> akpm2:/usr/src/25> grep -r _ASM_IA64_ELF_H arch/ia64
> arch/ia64/ia32/ia32priv.h:#define _ASM_IA64_ELF_H               /* Don't include elf.h */
> can you believe this stuff?

Oh, that's pretty crazy indeed. Including of binfmt_elf.c from all over 
the place is crazy as hell by itself, but this certainly adds a lot of 
additional mess. 

> Wanna see if there's something saner we can do please?

Apart from rewriting the whole thing to make more sense, I don't see 
currently a way out of it better than your patch :(

-- 
Jiri Kosina
SUSE Labs
