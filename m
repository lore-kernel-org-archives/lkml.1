Return-Path: <linux-kernel-owner+w=401wt.eu-S1761252AbXGUFjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761252AbXGUFjT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 01:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754577AbXGUFjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 01:39:04 -0400
Received: from mail.suse.de ([195.135.220.2]:34964 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553AbXGUFjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 01:39:03 -0400
From: Andi Kleen <ak@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC, Announce] Unified x86 architecture, arch/x86
Date: Sat, 21 Jul 2007 07:37:58 +0200
User-Agent: KMail/1.9.1
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Steven Rostedt <rostedt@goodmis.org>
References: <1184970779.4012.38.camel@chaos>
In-Reply-To: <1184970779.4012.38.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707210737.59552.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 July 2007 00:32, Thomas Gleixner wrote:
> We are pleased to announce a project we've been working on for some
> time: the unified x86 architecture tree, or "arch/x86" - and we'd like
> to solicit feedback about it.

Well you know my position on this. I think it's a bad idea because
it means we can never get rid of any old junk. IMNSHO arch/x86_64
is significantly cleaner and simpler in many ways than arch/i386 and I would
like to preserve that. Also in general arch/x86_64 is much easier to hack
than arch/i386 because it's easier to regression test and in general
has to care about much less junk. And I don't 
know of any way to ever fix that for i386 besides splitting the old
stuff off completely.

Besides radical file movements like this are bad anyways. They cause
a big break in patchkits and forward/backwards porting that doesn't 
really help anybody.

> This causes double maintenance
> even for functionality that is conceptually the same for the 32-bit and
> the 64-bit tree. (such as support for standard PC platform architecture
> devices)

It's not really the same platform: one is PC hardware going back forever
with zillions of bugs, the other is modern PC platforms which much less
bugs and quirks

To see it otherwise it's more a junkification of arch/x86_64 than
a cleanup of arch/i386 -- in fact you didn't really clean up arch/i386 
at all.

> How did we do it?
> -----------------
>
> As an initial matter, we made it painstakingly sure that the resulting
> .o files in a 32-bit build are bit for bit equal.

You got not a single line less code duplication then, so i don't really
see the point of this.

-Andi
