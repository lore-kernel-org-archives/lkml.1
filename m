Return-Path: <linux-kernel-owner+w=401wt.eu-S1755114AbZB1RxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114AbZB1RxV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 12:53:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbZB1RxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 12:53:12 -0500
Received: from casper.infradead.org ([85.118.1.10]:46375 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883AbZB1RxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 12:53:11 -0500
Date: Sat, 28 Feb 2009 09:53:25 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Salman Qazi <sqazi@google.com>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch] x86, mm: pass in 'total' to __copy_from_user_*nocache()
Message-ID: <20090228095325.186f5efc@infradead.org>
In-Reply-To: <alpine.LFD.2.00.0902280935010.3111@localhost.localdomain>
References: <20090224020304.GA4496@google.com>
	<200902272305.01867.nickpiggin@yahoo.com.au>
	<20090228082922.GB11425@elte.hu>
	<200902282249.57479.nickpiggin@yahoo.com.au>
	<20090228125816.GA14917@elte.hu>
	<alpine.LFD.2.00.0902280904271.3111@localhost.localdomain>
	<20090228092450.3ded2db5@infradead.org>
	<alpine.LFD.2.00.0902280935010.3111@localhost.localdomain>
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

On Sat, 28 Feb 2009 09:42:18 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> That's almost unacceptable in the long run. With a 8MB L3 cache - and
> a compile sequence, do we really want to go out to memory to write
> the .S file, and then have the assembler go out to memory to read it
> back? For a compile, that _probably_ is all fine (the compiler in
> particular will have enough data structures around that it's not
> going to fit in the cache anyway), but I'm seeing leaner compilers
> and other cases where forcing things out all the way on the bus is
> simply the wrong thing.

non-temporal is almost always wrong

one of the valid cases is where you KNOW you'll be doing dma for all of
the memory very shortly (say, an O_SYNC/O_DIRECT write of 4Kb) since
that would tend to evict it from cache anyway.

but beyond that... not so much.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
