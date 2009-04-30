Return-Path: <linux-kernel-owner+w=401wt.eu-S1763947AbZD3Nzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763947AbZD3Nzf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 09:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762233AbZD3NzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 09:55:20 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:62343 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1762222AbZD3NzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 09:55:17 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsFAD9E+UlMQW1W/2dsb2JhbACBUM4kg38F
Date: Thu, 30 Apr 2009 09:50:05 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Lameter <cl@linux.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, thomas.pi@arcor.dea,
       Yuriy Lalym <ylalym@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ltt-dev@lists.casi.polymtl.ca
Subject: Re: [PATCH] Fix dirty page accounting in
	redirty_page_for_writepage()
Message-ID: <20090430135005.GA5922@Krystal>
References: <20090429232546.GB15782@Krystal> <alpine.LFD.2.00.0904291701450.22156@localhost.localdomain> <20090430024303.GB19875@Krystal> <alpine.DEB.1.10.0904300921290.22262@qirst.com> <20090430133859.GB8329@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090430133859.GB8329@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:46:26 up 61 days, 10:12,  1 user,  load average: 0.62, 0.75,
	0.58
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Christoph Lameter <cl@linux.com> wrote:
> 
> > On Wed, 29 Apr 2009, Mathieu Desnoyers wrote:
> > 
> > > to have a good look at the memory accounting code. We could 
> > > probably benefit of Christoph Lameter's cpu ops (using segment 
> > > registers to address per-cpu variables with atomic inc/dec) in 
> > > there. Or at least removing interrupt disabling by using preempt 
> > > disable and local_t variables for the per-cpu counters could 
> > > bring some benefit.
> > 
> > Guess we are ready for atomic per cpu ops now that the new per cpu 
> > allocator is in? Segment register issues with the PDA are also 
> > solved right?
> 
> it's all done, implemented and upstream already. You are a bit late 
> to the party ;-)
> 
> 	Ingo

Or way too early, depending on the point of view. :-)

e.g.
http://lkml.org/lkml/2008/5/30/3

I think Christoph deserves credits for pioneering this area with fresh
ideas.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
