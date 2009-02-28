Return-Path: <linux-kernel-owner+w=401wt.eu-S1754919AbZB1RZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbZB1RZf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 12:25:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbZB1RYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 12:24:55 -0500
Received: from casper.infradead.org ([85.118.1.10]:41747 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbZB1RYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 12:24:54 -0500
Date: Sat, 28 Feb 2009 09:24:50 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Salman Qazi <sqazi@google.com>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch] x86, mm: pass in 'total' to __copy_from_user_*nocache()
Message-ID: <20090228092450.3ded2db5@infradead.org>
In-Reply-To: <alpine.LFD.2.00.0902280904271.3111@localhost.localdomain>
References: <20090224020304.GA4496@google.com>
	<200902272305.01867.nickpiggin@yahoo.com.au>
	<20090228082922.GB11425@elte.hu>
	<200902282249.57479.nickpiggin@yahoo.com.au>
	<20090228125816.GA14917@elte.hu>
	<alpine.LFD.2.00.0902280904271.3111@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Feb 2009 09:16:21 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Sat, 28 Feb 2009, Ingo Molnar wrote:
> > 
> > Can you suggest some other workload that should show sensitivity 
> > to this detail too? Like a simple write() loop of non-4K-sized 
> > files or so?
> 
> I bet you can find it, but I also suspect that it will depend quite a
> bit on the microarchitecture. What does 'movntq' actually _do_ on
> different CPU's (bypass L1 or L2 or just turn the L1 cache policy to
> "write through and invalidate")? 

Afaik it's like a cache flush followed by the equivalent of a WC store

> How expensive is the sfence when
> there are still stores in the write buffer? Does 'movqnt' even use
> the write buffer for cached stores, or is doing some special path the
> the last-level cache?

it's usually like a WC store
>
> If you want to be really subtle, ask questions like what are the 
> implications for last-level caches that are inclusive? The last-level 
> cache would take not just the new write, but it also has logic to
> make sure that it's a superset of the inner caches, so what does that
> do to replacement policy for that cache? Or does it cause
> invalidations in the inner caches?

it invalidates all caches in the hierarchy

afaik this is what Intel cpus do; but I also thought this behavior was
quite architectural as well...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
