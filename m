Return-Path: <linux-kernel-owner+w=401wt.eu-S1752760AbZCaHNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbZCaHNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 03:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbZCaHNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 03:13:42 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:37077 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbZCaHNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 03:13:41 -0400
Subject: Re: [patch 2/3] slub: scan partial list for free slabs when
	thrashing
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Martin Bligh <mbligh@google.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0903301033380.13333@qirst.com>
References: <alpine.DEB.2.00.0903292241300.15813@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.0903292242510.15813@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.0903292243050.15813@chino.kir.corp.google.com>
	 <alpine.DEB.1.10.0903301033380.13333@qirst.com>
Date: Tue, 31 Mar 2009 10:13:37 +0300
Message-Id: <1238483617.26587.32.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Mar 2009, David Rientjes wrote:
> > Whenever a cpu cache satisfies a fastpath allocation, a fastpath counter
> > is incrememted.  This counter is cleared whenever the slowpath is
> > invoked.  This tracks how many fastpath allocations the cpu slab has
> > fulfilled before it must be refilled.

On Mon, 2009-03-30 at 10:37 -0400, Christoph Lameter wrote:
> That adds fastpath overhead and it shows for small objects in your tests.

Yup, and looking at this:

+       u16 fastpath_allocs;    /* Consecutive fast allocs before slowpath */
+       u16 slowpath_allocs;    /* Consecutive slow allocs before watermark */

How much do operations on u16 hurt on, say, x86-64? It's nice that
sizeof(struct kmem_cache_cpu) is capped at 32 bytes but on CPUs that
have bigger cache lines, the types could be wider.

Christoph, why is struct kmem_cache_cpu not __cacheline_aligned_in_smp
btw?

			Pekka

