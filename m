Return-Path: <linux-kernel-owner+w=401wt.eu-S1757258AbYE3Fiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258AbYE3Fiu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 01:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbYE3Fil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 01:38:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34725 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752510AbYE3Fil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 01:38:41 -0400
Date: Thu, 29 May 2008 22:38:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>
Subject: Re: [patch 04/41] cpu ops: Core piece for generic atomic per cpu
 operations
Message-Id: <20080529223825.bf744d37.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0805292214280.12107@schroedinger.engr.sgi.com>
References: <20080530035620.587204923@sgi.com>
	<20080530040011.727424512@sgi.com>
	<20080529215844.609a3ac8.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0805292214280.12107@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008 22:17:55 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> > > local_t is also very specific to the x86 processor.
> > 
> > And alpha, m32r, mips and powerpc, methinks.  Probably others, but
> > people just haven't got around to it.
> 
> No local_t does not do the relocation of the address to the correct percpu 
> area. It requies disabling of interrupts etc.

No it doesn't.  Look:

static inline void local_inc(local_t *l)
{
	asm volatile(_ASM_INC "%0"
		     : "+m" (l->a.counter));
}

> Its not atomic (wrt 
> interrupts) because of that.
>

Yes it is.

> > I think I'll need to come back another time to understand all that ;)
> > 
> > Thanks for writing it up carefully.
> 
> Well this stuff is so large in scope that I have difficulties keeping 
> everything straight.
> 
> > I wonder if all this stuff should be in a new header file.
> > 
> > We could get lazy and include that header from percpu.h if needed.
> 
> But then its related to percpu operations and relies extensively on the 
> various percpu.h files in asm-generic and asm-arch and include/linux

Well that should be fixed.  We should never have mixed the
alloc_percpu() and DEFINE_PER_CPU things inthe same header.  They're
different.

otoh as you propose removing the old alloc_percpu() I guess the end
result is no worse than what we presently have.

