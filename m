Return-Path: <linux-kernel-owner+w=401wt.eu-S1758047AbYHaT2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047AbYHaT2R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 15:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756017AbYHaT2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 15:28:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:51352 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755906AbYHaT2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 15:28:01 -0400
Date: Sun, 31 Aug 2008 12:27:51 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Sanders <linux@sandersweb.net>, linux-kernel@vger.kernel.org,
       Jan Beulich <jbeulich@novell.com>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
Message-ID: <20080831122751.72afafb5@infradead.org>
In-Reply-To: <alpine.LFD.1.10.0808311140060.12958@nehalem.linux-foundation.org>
References: <200808311422.12525.linux@sandersweb.net>
	<alpine.LFD.1.10.0808311140060.12958@nehalem.linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 Aug 2008 11:47:04 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Sun, 31 Aug 2008, David Sanders wrote:
> >
> > I recently discovered that x86 kernels won't boot under Virtual PC.
> 
> What CPU does Virtual PC emulate? As far as Wikipedia is concerned
> (not that I'd take it on complete faith) it emulates a 32-bit Intel
> Pentium II.
> 
> And that commit makes the kernel use the "P6 nops" for such hardware. 
> Maybe Virtual PC doesn't support the newer intel nop things?
> 
> Intel docs say that it should be available on any intel CPU that has 
> CPUID.01H.EAX[11:8] = 0110B or 1111B. That's the "family ID", and
> Pentium II should have a family ID of 6 (ie that 0110B case).
> 
> So it sounds like a Virtual PC bug, but I dunno. And maybe we should
> just use the legcay nops for anything that isn't modern (ie P4+ or
> Core)?

it's probably even a security bug in that I don't see what would be
stopping a ring 3 user process from executing these instructions...

