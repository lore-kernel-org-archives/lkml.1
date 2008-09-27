Return-Path: <linux-kernel-owner+w=401wt.eu-S1753870AbYI0ROh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbYI0ROh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 13:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbYI0RO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 13:14:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:38744 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbYI0RO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 13:14:29 -0400
Subject: Re: [RFC PATCH] LTTng relay buffer allocation, read, write
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, Martin Bligh <mbligh@google.com>,
       prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, od@suse.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       David Wilder <dwilder@us.ibm.com>
In-Reply-To: <20080927134012.GA11930@Krystal>
References: <20080927134012.GA11930@Krystal>
Content-Type: text/plain
Date: Sat, 27 Sep 2008 19:10:18 +0200
Message-Id: <1222535419.16700.300.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-09-27 at 09:40 -0400, Mathieu Desnoyers wrote:
> As I told Martin, I was thinking about taking an axe and moving stuff around in
> relay. Which I just did.
> 
> This patch reimplements relay with a linked list of pages. Provides read/write
> wrappers which should be used to read or write from the buffers. It's the core
> of a layered approach to the design requirements expressed by Martin and
> discussed earlier.
> 
> It does not provide _any_ sort of locking on buffer data. Locking should be done
> by the caller. Given that we might think of very lightweight locking schemes, it
> makes sense to me that the underlying buffering infrastructure supports event
> records larger than 1 page.
> 
> A cache saving 3 pointers is used to keep track of current page used for the
> buffer for write, read and current subbuffer header pointer lookup. The offset
> of each page within the buffer is saved in the page frame structure to permit
> cache lookup without extra locking.
> 
> TODO : Currently, no splice file operations are implemented. Should come soon.
> The idea is to splice the buffers directly into files or to the network.
> 
> This patch is released as early RFC. It builds, that's about it. Testing will
> come when I implement the splice ops.

Why? What aspects of Steve's ring-buffer interface will hinder us
optimizing the implementation to be as light-weight as you like?

The thing is, I'd like to see it that light as well ;-)

As for the page-spanning entries, I think we can do that with Steve's
system just fine, its just that Linus said its a dumb idea and Steve
dropped it, but there is nothing fundamental stopping us from recording
a length that is > PAGE_SIZE and copying data into the pages one at a
time.

Nor do I see it impossible to implement splice on top of Steve's
ring-buffer..

So again, why?

