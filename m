Return-Path: <linux-kernel-owner+w=401wt.eu-S932765AbYARWef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765AbYARWef (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 17:34:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760670AbYARWe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 17:34:27 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57695 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190AbYARWe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 17:34:26 -0500
Date: Fri, 18 Jan 2008 14:33:34 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: fche@redhat.com (Frank Ch. Eigler)
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2/3] Latencytop instrumentations part 1
Message-ID: <20080118143334.28ba08ca@laptopd505.fenrus.org>
In-Reply-To: <y0mmyr2ydmm.fsf@ton.toronto.redhat.com>
References: <4790E3A6.7060807@linux.intel.com>
	<20080118094048.10e79ff9@laptopd505.fenrus.org>
	<y0mmyr2ydmm.fsf@ton.toronto.redhat.com>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2008 17:26:09 -0500
fche@redhat.com (Frank Ch. Eigler) wrote:

> Arjan van de Ven <arjan@infradead.org> writes:
> 
> > This patch contains the first set of instrumentations for
> > latencytop; each instrumentation needs to be evaluated for
> > usefulness before this can go into mainline; posting here just to
> > show how the infrastructure can be used
> > [...]
> 
> Can you suggest of some reason why all this instrumentation could
> not be in the form of standard markers (perhaps conditionally
> compiled out if necessary)?
> 

sure. Every instrumentation you see is of the nested kind (since the lowest level
of nesting is already automatic via wchan).

If markers can provide me the following semantics, I'd be MORE than happy to use markers:

If the code path is like this


set_latency_reason("Reading file");
    ....
    ....
          set_latency_reason("Allocating memory");
          kmalloc()  <--- blocks for 100 msec
          restore_latency_reason()
    ....
restore_latency_reason();

via several layers of functions, the requirement is that the 100 msec is accounted 
to "reading file" and not "Allocating memory". But if some other codepath hits the allocating memory function,
without an outer "set_latency_reason", it should be accounted to "Allocating memory".

If markers can provide that semantics ... you sold me.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
