Return-Path: <linux-kernel-owner+w=401wt.eu-S1751762AbZKWFuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbZKWFuU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 00:50:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbZKWFuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 00:50:19 -0500
Received: from ozlabs.org ([203.10.76.45]:56429 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbZKWFuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 00:50:18 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19210.8856.446670.786636@cargo.ozlabs.ibm.com>
Date: Mon, 23 Nov 2009 16:50:16 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/15] perf: optimize perf_swevent_ctx_event()
In-Reply-To: <20091120212508.378188589@chello.nl>
References: <20091120211942.676891948@chello.nl>
	<20091120212508.378188589@chello.nl>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> We can do away with the system_state check if the machine still boots
> after this patch (seems to be the case).

I have a recollection (possible faulty) that the problem we can get
into if we don't have this check is that if we take a bad page fault
in the kernel (e.g. NULL dereference) early in boot before the perf
cpu context has been initialized, we then get another NULL dereference
because the pointers in ctx->event_list are NULL, and recurse to
death.

So that check was possibly more about debugging than correctness.
Possibly also the x86 do_page_fault() is different enough from the
powerpc one that the problem can't occur on x86.

Paul.
