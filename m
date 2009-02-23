Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbZBWOAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbZBWOAq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 09:00:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbZBWOAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 09:00:38 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:43425 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330AbZBWOAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 09:00:37 -0500
Subject: Re: [PATCH] mm: gfp_to_alloc_flags()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mel@csn.ul.ie>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
In-Reply-To: <1235390103.4645.80.camel@laptop>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie>
	 <1235390103.4645.80.camel@laptop>
Date: Mon, 23 Feb 2009 16:00:35 +0200
Message-Id: <1235397635.6216.62.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-23 at 12:55 +0100, Peter Zijlstra wrote:
> Subject: mm: gfp_to_alloc_flags()
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Mon Feb 23 12:46:36 CET 2009
> 
> Clean up the code by factoring out the gfp to alloc_flags mapping.
> 
> [neilb@suse.de says]
> As the test:
> 
> -       if (((p->flags & PF_MEMALLOC) || unlikely(test_thread_flag(TIF_MEMDIE)))
> -                       && !in_interrupt()) {
> -               if (!(gfp_mask & __GFP_NOMEMALLOC)) {
> 
> has been replaced with a slightly weaker one:
> 
> +       if (alloc_flags & ALLOC_NO_WATERMARKS) {
> 
> we need to ensure we don't recurse when PF_MEMALLOC is set
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

