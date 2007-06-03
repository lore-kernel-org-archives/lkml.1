Return-Path: <linux-kernel-owner+w=401wt.eu-S1764246AbXFCGnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764246AbXFCGnk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 02:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756394AbXFCGne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 02:43:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46328 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755949AbXFCGnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 02:43:33 -0400
Date: Sun, 3 Jun 2007 08:43:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch 2/2] ufd v1 - use unsequential O(1) fdmap
Message-ID: <20070603064322.GA12576@elte.hu>
References: <send-serie.davidel@xmailserver.org.24319.1180825146.2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <send-serie.davidel@xmailserver.org.24319.1180825146.2>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Davide Libenzi <davidel@xmailserver.org> wrote:

> This patch plugs the extended fdmap into the kernel. At the moment, this
> is done only through sys_dup2() and F_DUPFD.
> The base value for the unsequential file descriptor allocation is (at the
> moment) set to FD_UNSEQ_BASE (defined in asm-generic/fcntl.h):

really nice stuff! :-)

> #define FD_UNSEQ_BASE	(1U << 28)
> #define FD_UNSEQ_ALLOC  (1U << 30)

i'm wondering, why not use (1 << 30) both as the base and as the flag? 
That would make integration of the new fd space 'seemless' in terms of 
dup2() use.

> It'd be possible to add a new O_UNSEQFD flag to open(2) and make 
> sys_open() to allocate the new descriptor inside the unsequential map.

yeah, please do that now - lets not leave any incomplete areas. We've 
too often made the mistake of not pushing through new APIs consistently 
enough.

I'd also suggest a new sys_socket2() call that takes a 'flags' parameter 
as well - because one primary user of this facility will be networking 
servers. (O_UNSEQFD would make sense for it and O_NDELAY - currently 
network apps that want to set O_NDELAY need to do it with an extra 
fcntl() - while they could already indicate this in the sys_socket() 
call, if it were closer to sys_open() semantics)

in any case, your patch is looking really good and already deserves an 
ack!

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
