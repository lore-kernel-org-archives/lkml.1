Return-Path: <linux-kernel-owner+w=401wt.eu-S1755206Ab0AWLw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab0AWLw6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 06:52:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754884Ab0AWLw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 06:52:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151Ab0AWLw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 06:52:56 -0500
Date: Sat, 23 Jan 2010 06:51:49 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kyle Moffett <kyle@moffetthome.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: add utrace tree
Message-ID: <20100123115149.GB7828@redhat.com>
References: <20100121170541.7425ff10.akpm@linux-foundation.org> <alpine.LFD.2.00.1001211724500.13231@localhost.localdomain> <20100122182827.GA13185@redhat.com> <20100122200129.GG22003@redhat.com> <alpine.LFD.2.00.1001221355250.13231@localhost.localdomain> <20100122221348.GA4263@redhat.com> <alpine.LFD.2.00.1001221604190.13231@localhost.localdomain> <alpine.LFD.2.00.1001221614520.13231@localhost.localdomain> <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com> <20100123110121.1ce89bb9@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100123110121.1ce89bb9@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Sat, Jan 23, 2010 at 11:01:21AM +0000, Alan Cox wrote:
> [...]
> What I don't understand is why [libgdb?] doesn't solve 99% of your problem.
> ptrace is not perfect but most of the real ptrace limitations actually
> come about because either the CPU can't do something or because the
> supporting logic would be too expensive - things like having extra
> private debugger pages.

At least one reason is that ptrace is single-usage-only, so for
example you cannot concurrently debug & strace the same program.
OTOH, utrace is designed to permit clean nesting/sharing semantics for
concurrent debugger-type tools operating on the same processes.

- FChE
