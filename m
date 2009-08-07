Return-Path: <linux-kernel-owner+w=401wt.eu-S1757220AbZHGINZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220AbZHGINZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 04:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757200AbZHGINY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 04:13:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:46714 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757192AbZHGINX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 04:13:23 -0400
Subject: Re: [PATCH] perf tools: Fix cumul hit based sub-total
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <1249621865-9325-1-git-send-email-fweisbec@gmail.com>
References: <1249621865-9325-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 07 Aug 2009 10:12:58 +0200
Message-Id: <1249632778.32113.608.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-07 at 07:11 +0200, Frederic Weisbecker wrote:
> The callchain fractal mode builds each new total hits in a new branch
> of profiling by using the parent's hits of the current branch plus the
> hits of the children.
> 
> This is wrong, the total hits of a branch should be made of the sum of
> every children hits, we must ignore the parent hits in this scope.
> 
> This patch also fixes another mistakes with the hit counting.
> 
> Now the rates are corrects.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Mike Galbraith <efault@gmx.de>
> ---

Ah will this fix these instances where you'd have things like

                |                     page_fault
                |                     |
                |                     |--100.00%-- __strcmp_sse2
                |                     |          copy_dep_chain
                |                     |          __libc_start_main
                |                     |
                |                      --100.00%-- gettimeofday
                |                                __libc_start_main


I was meaning to poke you about that :-)
