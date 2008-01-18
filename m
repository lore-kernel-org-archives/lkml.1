Return-Path: <linux-kernel-owner+w=401wt.eu-S1764475AbYARXNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764475AbYARXNW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 18:13:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758529AbYARXNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 18:13:11 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762387AbYARXNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 18:13:09 -0500
Date: Fri, 18 Jan 2008 18:11:09 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2/3] Latencytop instrumentations part 1
Message-ID: <20080118231109.GC27193@redhat.com>
References: <4790E3A6.7060807@linux.intel.com> <20080118094048.10e79ff9@laptopd505.fenrus.org> <y0mmyr2ydmm.fsf@ton.toronto.redhat.com> <20080118143334.28ba08ca@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080118143334.28ba08ca@laptopd505.fenrus.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Fri, Jan 18, 2008 at 02:33:34PM -0800, Arjan van de Ven wrote:
> [...]
> > Can you suggest of some reason why all this instrumentation could
> > not be in the form of standard markers (perhaps conditionally
> > compiled out if necessary)?
> 
> sure. Every instrumentation you see is of the nested kind (since the lowest level
> of nesting is already automatic via wchan).
> If markers can provide me the following semantics, I'd be MORE than happy to use markers:
> [...]
> If markers can provide that semantics ... you sold me.

Further to what acme said, markers are semantics-free.  Callback
functions that implement your entry & exit semantics can be attached
at run time, at your pleasure.  (So can systemtap probes, for that
matter.)  The main difference would be that these callback functions
would have manage the per-thread LIFO data structures themselves,
instead of allocating backpointers on the kernel stack.  (Bonus marks
for not modifying task_struct. :-)

- FChE
