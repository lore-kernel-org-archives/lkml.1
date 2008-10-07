Return-Path: <linux-kernel-owner+w=401wt.eu-S1754628AbYJGQLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbYJGQLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 12:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbYJGQLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 12:11:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58263 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272AbYJGQK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 12:10:59 -0400
Subject: Re: [BUG] SLOB's krealloc() seems bust
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Matt Mackall <mpm@selenic.com>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1223391655.13453.344.camel@calx>
References: <1223387841.26330.36.camel@lappy.programming.kicks-ass.net>
	 <48EB6D2C.30806@linux-foundation.org>  <1223391655.13453.344.camel@calx>
Content-Type: text/plain
Date: Tue, 07 Oct 2008 18:10:45 +0200
Message-Id: <1223395846.26330.55.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-07 at 10:00 -0500, Matt Mackall wrote:
> Give this a try, please:
> 
> diff -r 5e32b09a1b2b mm/slob.c
> --- a/mm/slob.c Fri Oct 03 14:04:43 2008 -0500
> +++ b/mm/slob.c Tue Oct 07 10:00:16 2008 -0500
> @@ -515,7 +515,7 @@
>  
>         sp = (struct slob_page *)virt_to_page(block);
>         if (slob_page(sp))
> -               return ((slob_t *)block - 1)->units + SLOB_UNIT;
> +               return (((slob_t *)block - 1)->units - 1) * SLOB_UNIT;
>         else
>                 return sp->page.private;
>  }

That seems to make it work again! (4 reboots, 0 crashes)

Tested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Thanks!

