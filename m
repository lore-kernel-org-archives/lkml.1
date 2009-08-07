Return-Path: <linux-kernel-owner+w=401wt.eu-S1757245AbZHGIWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245AbZHGIWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 04:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757090AbZHGIWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 04:22:22 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:53357 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757065AbZHGIWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 04:22:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=haKFqzMJGOVxCztC1n3KCD8GZVSzSbXXl1C+s1ZbZjLqReTE8Fs2S8vio0hMBNr+lW
         8VdueOJxuTMvzQFUlw59nrE4SXOv4OJbAWjzOf2aZPZ8NUgEEBvYgvwJn9e79xbrDdxs
         hTmZhYmbMaqq4h1MKtRSQ71+uaa6QbTMu7sQo=
Date: Fri, 7 Aug 2009 10:22:16 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] perf tools: Fix cumul hit based sub-total
Message-ID: <20090807082214.GC4955@nowhere>
References: <1249621865-9325-1-git-send-email-fweisbec@gmail.com> <1249632778.32113.608.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249632778.32113.608.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 10:12:58AM +0200, Peter Zijlstra wrote:
> On Fri, 2009-08-07 at 07:11 +0200, Frederic Weisbecker wrote:
> > The callchain fractal mode builds each new total hits in a new branch
> > of profiling by using the parent's hits of the current branch plus the
> > hits of the children.
> > 
> > This is wrong, the total hits of a branch should be made of the sum of
> > every children hits, we must ignore the parent hits in this scope.
> > 
> > This patch also fixes another mistakes with the hit counting.
> > 
> > Now the rates are corrects.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Mike Galbraith <efault@gmx.de>
> > ---
> 
> Ah will this fix these instances where you'd have things like
> 
>                 |                     page_fault
>                 |                     |
>                 |                     |--100.00%-- __strcmp_sse2
>                 |                     |          copy_dep_chain
>                 |                     |          __libc_start_main
>                 |                     |
>                 |                      --100.00%-- gettimeofday
>                 |                                __libc_start_main



I haven't met such huge rate's mistake yet :)
It was more about +-20% of imprecision.

I guess this patch should fix what you've met. If you still see that,
please tell me.

BTW, I will soon add a debug option to check the percentage correctness
and things like that...

