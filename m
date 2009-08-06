Return-Path: <linux-kernel-owner+w=401wt.eu-S1754641AbZHFQcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbZHFQcj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 12:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751807AbZHFQcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 12:32:39 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:24488 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751552AbZHFQci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 12:32:38 -0400
X-IronPort-AV: E=Sophos;i="4.43,334,1246831200"; 
   d="scan'208";a="30862046"
Message-ID: <4A7B05B1.5000807@inria.fr>
Date: Thu, 06 Aug 2009 18:32:49 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf_counter: fix double list iteration
References: <4A7A7778.7000000@inria.fr>  <1249573080.32113.547.camel@twins> <1249574786.32113.550.camel@twins>
In-Reply-To: <1249574786.32113.550.camel@twins>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tested-by: Brice Goglin <Brice.Goglin@inria.fr>

Thanks!


Peter Zijlstra wrote:
> ---
> Subject: perf_counter: fix double list iteration
>
> A silly copy-paste resulted in a messed up iteration which would cause
> an OOPS.
>
> Reported-by: Brice Goglin <Brice.Goglin@inria.fr>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/perf_counter.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
> index 06d210c..6da7611 100644
> --- a/kernel/perf_counter.c
> +++ b/kernel/perf_counter.c
> @@ -1104,7 +1104,7 @@ static void perf_counter_sync_stat(struct perf_counter_context *ctx,
>  		__perf_counter_sync_stat(counter, next_counter);
>  
>  		counter = list_next_entry(counter, event_entry);
> -		next_counter = list_next_entry(counter, event_entry);
> +		next_counter = list_next_entry(next_counter, event_entry);
>  	}
>  }
>  
>
>   

