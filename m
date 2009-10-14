Return-Path: <linux-kernel-owner+w=401wt.eu-S1761901AbZJNPnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761901AbZJNPnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761156AbZJNPnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:43:42 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:44671 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758829AbZJNPnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:43:41 -0400
Date: Wed, 14 Oct 2009 11:31:29 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: David Rientjes <rientjes@google.com>
cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>, Tejun Heo <tj@kernel.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: this_cpu_xx's patchset effect on SLUB cycle counts
In-Reply-To: <alpine.DEB.1.00.0910131958040.26072@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0910141125040.26476@gentwo.org>
References: <alpine.DEB.1.10.0910131603380.7246@gentwo.org> <alpine.DEB.1.00.0910131958040.26072@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009, David Rientjes wrote:

> I benchmarked this patchset both with and without the irqless patch from
> http://marc.info/?l=linux-kernel&m=125503037213262 on several of my
> machines.  The results were good for the most part, but I found a very
> reproducible regression on my 4-core 8G Xeon 5500 with HyperThreading for
> objects of smaller size (8, 16, and 64 bytes) without the irqless patch:

Hmmm... Strange. Maybe different icache cacheline code placement? There is
no change in data structures without the irqless patch.

Can you change some kernel config options that impact memory and code
layout and rerun? Just to make sure that this is not a freak thing due to
code placement. Are sure sure that the kernel tested had the patches
applied?

> But "Kernel C" (with the irqless patch) shows a major improvement in the
> single threaded tests:

C changes per cpu layout a bit as well as does code changes.

> 2. Kmalloc: alloc/free test
> 10000 times kmalloc(8)/kfree -> 132 cycles

Was the kernel compiled with preemption on? I get cycle numbers with two
digits on these tests using quad nehalems.

> "Kernel C" hangs on my netserver machine during netperf -t TCP_RR -l 60,
> though, so hopefully I'll be able to obtain results for that benchmark
> with the irqless patch and see if there's any noticable improvement once
> it's debugged.

irqless is a risky patch. There may still be issues there. Thanks for
testing it.


