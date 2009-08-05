Return-Path: <linux-kernel-owner+w=401wt.eu-S934232AbZHENFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934232AbZHENFS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 09:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934299AbZHENFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 09:05:17 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:49110 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933658AbZHENFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 09:05:13 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 4/4] tracing, page-allocator: Add a postprocessing
 script for page-allocator-related ftrace events
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, penberg@cs.helsinki.fi,
       fweisbec@gmail.com, rostedt@goodmis.org, mel@csn.ul.ie,
       lwoodman@redhat.com, riel@redhat.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20090804203526.GA8699@elte.hu>
References: <1249409546-6343-1-git-send-email-mel@csn.ul.ie>
	 <1249409546-6343-5-git-send-email-mel@csn.ul.ie>
	 <20090804112246.4e6d0ab1.akpm@linux-foundation.org>
	 <20090804195717.GA5998@elte.hu>
	 <20090804131818.ee5d4696.akpm@linux-foundation.org>
	 <20090804203526.GA8699@elte.hu>
Content-Type: text/plain
Date: Wed, 05 Aug 2009 15:04:54 +0200
Message-Id: <1249477494.32113.4.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-04 at 22:35 +0200, Ingo Molnar wrote:

> Did you never want to see whether firefox is leaking [any sort of] 
> memory, and if yes, on what callsites? Try something like on an 
> already running firefox context:
> 
>   perf stat -e kmem:mm_page_alloc \
>             -e kmem:mm_pagevec_free \
>             -e kmem:mm_page_free_direct \
>      -p $(pidof firefox-bin) sleep 10
> 
> .... and "perf record" for the specific callsites.

If these tracepoints were to use something like (not yet in mainline)

  TP_perf_assign(
 	__perf_data(obj);
  ),

Where obj was the thing being allocated/freed, you could, when using
PERF_SAMPLE_ADDR even match up alloc/frees, combined with
PERF_SAMPLE_CALLCHAIN you could then figure out where the unmatched
entries came from.

Might be useful, dunno.


