Return-Path: <linux-kernel-owner+w=401wt.eu-S1758179AbZCZCnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179AbZCZCnO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 22:43:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754961AbZCZCm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 22:42:58 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:34150 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238AbZCZCm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 22:42:57 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18890.59107.116394.771297@drongo.ozlabs.ibm.com>
Date: Thu, 26 Mar 2009 13:22:27 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 5/6] perf_counter: kerneltop: mmap_pages argument
In-Reply-To: <1237984033.7972.865.camel@twins>
References: <20090325113021.781490788@chello.nl>
	<20090325113317.104545398@chello.nl>
	<20090325121811.GC11571@elte.hu>
	<1237984033.7972.865.camel@twins>
X-Mailer: VM 8.0.12 under 22.2.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> One possible solution is making the control page writable and writing
> the userspace read position to it, then the kernel can, on
> perf_output_begin() detect the overflow and count the number of
> overwritten events.
> 
> This overflow count could then be published back into the control page.

We could in principle have many different processes mmapping the same
counter and reading the ring buffer, couldn't we?  So which process
gets to put its read position in the control page?

> TBH I'm not much of a fan, making all these pages writable just opens a
> whole can of worms, and that accurate overflow tracking will put more
> code in the output path.

I agree.

Paul.
