Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbZLAXrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbZLAXrd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 18:47:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754715AbZLAXrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 18:47:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754629AbZLAXrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 18:47:32 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
X-Fcc: ~/Mail/utrace
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, utrace-devel@redhat.com,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [RFC,PATCH 14/14] utrace core
In-Reply-To: Andi Kleen's message of  Tuesday, 24 November 2009 21:32:27 +0100 <87my2bwtno.fsf@basil.nowhere.org>
References: <20091124200220.GA5828@redhat.com>
	<87my2bwtno.fsf@basil.nowhere.org>
Emacs: don't cry -- it won't help.
Message-Id: <20091201234704.40D4D86D@magilla.sf.frob.com>
Date: Tue,  1 Dec 2009 15:47:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Could we just drop the tracehook layer if this finally merged
> and call the low level functions directly?

We can certainly do appropriate streamlining cleanups later, by all
means.  The original purpose of the tracehook layer is simply this:

A person hacking on core kernel code or arch code should not have to
think about all the innards of tracing (ptrace, utrace, or anything
else).  If he comes across a tracehook_* call, he can just read its
kernel-doc for explanation of its parameters, return value, what it
expects about its context (locking et al), and what the semantic
significance of making that particular call is.  If changes to the
core/arch code in question do not require changing any of those
aspects, then said person need not consider tracing issues further.
If a change to a function's calling interface or contextual
assumptions looks warranted, then he knows he should discuss the
details with some tracing-related folks (i.e. find tracehook.h in
MAINTAINERS and thus get to me and Oleg).

Likewise, a person hacking on tracing code should not have to think
about every corner of interaction with the core code or arch code.
Each tracehook_* call's kernel-doc comments say everything that
matters about how and where it's called.  If some of those details
are problematic for what we want to do inside the tracing code, then
we know we have to hash out the details with the maintainers of the
core or arch code that makes those calls.  Otherwise we can keep our
focus on tracing infrastructure without spending time getting lost
in arcane details of the arch or core kernel code.

These two things seem permanently worthwhile to me: that the core
and arch source code use simple function calls without open-coding
any innards of the tracing infrastructure; and that these functions
have clear and complete documentation about their calling interfaces
and context (locking et al).  I find it natural and convenient that
such calls have a common prefix that makes it obvious to any reader
of the core code what subsystem the call relates to.

Beyond those ideas, I certainly don't care at all what the names of
these functions are, what common prefix is used, or in which source
files those declarations and kernel-doc comments appear.


Thanks,
Roland
