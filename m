Return-Path: <linux-kernel-owner+w=401wt.eu-S1752509AbZJQPch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509AbZJQPch (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 11:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbZJQPch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 11:32:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:50984 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbZJQPcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 11:32:36 -0400
Subject: Re: Mutex vs semaphores scheduler bug
From: Peter Zijlstra <peterz@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: =?ISO-8859-1?Q?T=F6r=F6k?= Edwin <edwin@clamav.net>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, aCaB <acab@clamav.net>,
       Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <24718.1255650266@redhat.com>
References: <1255359207.10420.31.camel@twins> <4AD0A0F7.9070700@clamav.net>
	 <24718.1255650266@redhat.com>
Content-Type: text/plain
Date: Sat, 17 Oct 2009 17:32:07 +0200
Message-Id: <1255793527.8152.4.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-16 at 00:44 +0100, David Howells wrote:
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > The problem appears to be that rwsem doesn't allow lock-stealing
> 
> With good reason.  rwsems can be read or write locked for a long time - so if
> readers can jump the queue on read-locked rwsems, then writer starvation is a
> real possibility.  I carefully implemented it so that it is a strict FIFO to
> avoid certain problems I was having.

Well, it kinda sucks that rwsem is slower than a mutex.

What about allowing writer stealing when the next contending task is a
writer?

