Return-Path: <linux-kernel-owner+w=401wt.eu-S1756860AbXJaAOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860AbXJaAOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 20:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbXJaAOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 20:14:07 -0400
Received: from ns2.suse.de ([195.135.220.15]:45298 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475AbXJaAOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 20:14:06 -0400
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH] dump_stack on panic
From: Andi Kleen <andi@firstfloor.org>
References: <1193788979.5623.43.camel@localhost.localdomain>
Date: Wed, 31 Oct 2007 01:14:04 +0100
In-Reply-To: <1193788979.5623.43.camel@localhost.localdomain> (Steven Rostedt's message of "Tue\, 30 Oct 2007 20\:02\:59 -0400")
Message-ID: <p73odeg2l9v.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

> Is there any reason why we don't do a dump_stack on panic?

One (mostly psychological, but still serious) problem is that stack
dumps make panics always look like kernel bugs.  But there are panics
which are definitely not kernel bugs: like the popular cannot mount
root or machine checks or a couple of others.

We do not want users to send all these panics to linux-kernel
and they would if they look too much like kernel bugs.

I think it's in principle a good idea, but only if you
distingush the cases which are not kernel bugs.
e.g. use a different panic() call for them that does not dump.

-Andi
