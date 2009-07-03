Return-Path: <linux-kernel-owner+w=401wt.eu-S1757461AbZGCSJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461AbZGCSJm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 14:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897AbZGCSJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 14:09:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:38417 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbZGCSJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 14:09:34 -0400
Date: Fri, 3 Jul 2009 11:10:33 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] x86: atomic64: inline atomic64_read()
Message-ID: <20090703111033.6e9627de@infradead.org>
In-Reply-To: <20090703180450.GB3405@elte.hu>
References: <alpine.LFD.2.01.0907021653030.3210@localhost.localdomain>
	<tip-9103cab145a93cef13378632b332a824758a2f6f@git.kernel.org>
	<4A4E1AA2.30002@gmail.com>
	<20090703180450.GB3405@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Jul 2009 20:04:50 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> > +static inline u64 atomic64_read(atomic64_t *ptr)
> > +{
> > +	u64 res;
> > +
> > +	asm volatile(
> > +		"mov %%ebx, %%eax\n\t"
> > +		"mov %%ecx, %%edx\n\t"
> > +		LOCK_PREFIX "cmpxchg8b %1\n"

also afaik cmpxchg implies the lock prefix, so no need to make an
explicit one... it just adds code size and alternatives-work
