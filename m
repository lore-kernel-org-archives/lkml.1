Return-Path: <linux-kernel-owner+w=401wt.eu-S1760670AbYARWsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760670AbYARWsI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 17:48:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932320AbYARWrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 17:47:52 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932351AbYARWrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 17:47:49 -0500
Date: Fri, 18 Jan 2008 20:47:22 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2/3] Latencytop instrumentations part 1
Message-ID: <20080118224722.GB14456@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Arjan van de Ven <arjan@infradead.org>,
	"Frank Ch. Eigler" <fche@redhat.com>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>
References: <4790E3A6.7060807@linux.intel.com> <20080118094048.10e79ff9@laptopd505.fenrus.org> <y0mmyr2ydmm.fsf@ton.toronto.redhat.com> <20080118143334.28ba08ca@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080118143334.28ba08ca@laptopd505.fenrus.org>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jan 18, 2008 at 02:33:34PM -0800, Arjan van de Ven escreveu:
> On Fri, 18 Jan 2008 17:26:09 -0500
> fche@redhat.com (Frank Ch. Eigler) wrote:
> 
> > Arjan van de Ven <arjan@infradead.org> writes:
> > 
> > > This patch contains the first set of instrumentations for
> > > latencytop; each instrumentation needs to be evaluated for
> > > usefulness before this can go into mainline; posting here just to
> > > show how the infrastructure can be used
> > > [...]
> > 
> > Can you suggest of some reason why all this instrumentation could
> > not be in the form of standard markers (perhaps conditionally
> > compiled out if necessary)?
> > 
> 
> sure. Every instrumentation you see is of the nested kind (since the lowest level
> of nesting is already automatic via wchan).
> 
> If markers can provide me the following semantics, I'd be MORE than happy to use markers:
> 
> If the code path is like this
> 
> 
> set_latency_reason("Reading file");
>     ....
>     ....
>           set_latency_reason("Allocating memory");
>           kmalloc()  <--- blocks for 100 msec
>           restore_latency_reason()
>     ....
> restore_latency_reason();
> 
> via several layers of functions, the requirement is that the 100 msec is accounted 
> to "reading file" and not "Allocating memory". But if some other codepath hits the allocating memory function,
> without an outer "set_latency_reason", it should be accounted to "Allocating memory".
> 
> If markers can provide that semantics ... you sold me.

My limited understanding of markers is that you can attach something to
them that later work out any semantics you may want to associate with
them.

So I guess that as soon as the outermost marker is reached you can
just bump a counter and when the (several) inner markers are reached and
the counter is not zero you just bump it and go on with life, leaving
the latency measurement being done to the "owner" (outermost) marker.

Frank, am I talking bullshit?

- Arnaldo
