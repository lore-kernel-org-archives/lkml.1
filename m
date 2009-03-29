Return-Path: <linux-kernel-owner+w=401wt.eu-S1755161AbZC2KTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbZC2KTe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 06:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754505AbZC2KTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 06:19:24 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:58300 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754292AbZC2KTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 06:19:23 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18895.18217.393755.824092@cargo.ozlabs.ibm.com>
Date: Sun, 29 Mar 2009 21:02:17 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH 1/9] perf_counter: unify and fix delayed counter wakeup
In-Reply-To: <1238318710.23852.38.camel@twins>
References: <20090328194359.426029037@chello.nl>
	<20090328194929.451591360@chello.nl>
	<18894.48499.125187.92480@cargo.ozlabs.ibm.com>
	<1238318201.23852.17.camel@twins>
	<1238318710.23852.38.camel@twins>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> In a perfect world, I'd introduce a self-ipi on UP and use that. Also,
> in that same perfect world, all arches would support cmpxchg()/xchg() so
> we could put the whole thing in generic code.

We already require atomic64_t, which not all architectures have - in
particular, ppc32 doesn't have it, though it does have cmpxchg/xchg
for 32-bit quantities.  The list of architectures that have atomic64_t
seems to be a proper subset of the list of architectures that have
cmpxchg, from a quick grep.  So I would think you can use cmpxchg if
necessary.

Paul.
