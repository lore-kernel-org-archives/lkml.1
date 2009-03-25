Return-Path: <linux-kernel-owner+w=401wt.eu-S1758592AbZCYJnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592AbZCYJnY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 05:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758690AbZCYJnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 05:43:05 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:49364 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755218AbZCYJnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 05:43:03 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18889.64659.917207.685779@cargo.ozlabs.ibm.com>
Date: Wed, 25 Mar 2009 20:42:43 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_counter: allow and require one-page mmap on
	counting counters
In-Reply-To: <20090325090336.GC2341@elte.hu>
References: <18889.59409.260586.87939@cargo.ozlabs.ibm.com>
	<20090325082844.GA11217@elte.hu>
	<18889.61903.636761.471281@cargo.ozlabs.ibm.com>
	<20090325090336.GC2341@elte.hu>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> ah - ok. Morning confusion. (any email from me that comes at single 
> digit hour local time should be considered fundamentally suspect ;-)

:)

> Wouldnt it still be better to keep the symmetry between counting and 
> sampling counters? In theory we could transit between these stags 
> and 'switch off' a sampling counter or 'switch on' a counting 
> counter - via an ioctl or so. Shouldnt counting counters be sampling 
> counters that were created while disabled temporarily?

Well, the buffer size can already be changed on the fly, by unmapping
the counter and remapping.  So, shouldn't I be allowed to select a
zero-sized ring buffer at the times when I'm not sampling, i.e. when
it's a counting counter?

And here's something else that is semi-related: the PAPI guys want a
kind of counter that counts until it overflows, and then sends a
signal to the process and disables itself (and the whole group it's
in).  The signal handler can then record whatever application-specific
information is interesting, re-enable the counter and return.  It
seems to be a way to do profiling where what you're recording is
something specific to the program rather than generic things like the
instruction pointer.

So that could be a case where we want a sampling counter that doesn't
generate any event records in the kernel, and so a 0-sized ring buffer
could be appropriate.

Paul.
