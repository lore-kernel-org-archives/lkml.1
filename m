Return-Path: <linux-kernel-owner+w=401wt.eu-S1754613AbZKWHbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbZKWHbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 02:31:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbZKWHbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 02:31:38 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45411 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbZKWHbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 02:31:37 -0500
Subject: Re: [PATCH 03/15] perf: optimize perf_swevent_ctx_event()
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <19210.8856.446670.786636@cargo.ozlabs.ibm.com>
References: <20091120211942.676891948@chello.nl>
	 <20091120212508.378188589@chello.nl>
	 <19210.8856.446670.786636@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Nov 2009 08:31:40 +0100
Message-ID: <1258961500.4531.38.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-23 at 16:50 +1100, Paul Mackerras wrote:
> Peter Zijlstra writes:
> 
> > We can do away with the system_state check if the machine still boots
> > after this patch (seems to be the case).
> 
> I have a recollection (possible faulty) that the problem we can get
> into if we don't have this check is that if we take a bad page fault
> in the kernel (e.g. NULL dereference) early in boot before the perf
> cpu context has been initialized, we then get another NULL dereference
> because the pointers in ctx->event_list are NULL, and recurse to
> death.
> 
> So that check was possibly more about debugging than correctness.
> Possibly also the x86 do_page_fault() is different enough from the
> powerpc one that the problem can't occur on x86.

Right, I remembered there was _something_ we added them for, but
couldn't for the live of me remember what.

Hmm, maybe we can initialize all the recursion variables to 1, that
should avoid us ever entering into the swcounter code until we reset
them.

