Return-Path: <linux-kernel-owner+w=401wt.eu-S1755363AbZEHEzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbZEHEzR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 00:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbZEHEzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 00:55:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52762 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752131AbZEHEzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 00:55:01 -0400
Date: Thu, 7 May 2009 21:52:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/4] ring-buffer: add total count in
 ring-buffer-benchmark
Message-Id: <20090507215258.6227128c.akpm@linux-foundation.org>
In-Reply-To: <20090508043331.493337344@goodmis.org>
References: <20090508043250.372421144@goodmis.org>
	<20090508043331.493337344@goodmis.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 May 2009 00:32:53 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:

> --- a/kernel/trace/ring_buffer_benchmark.c
> +++ b/kernel/trace/ring_buffer_benchmark.c
> @@ -285,6 +285,17 @@ static void ring_buffer_producer(void)
>  		avg = 1000000 / hit;
>  		pr_info("%ld ns per entry\n", avg);
>  	}
> +
> +

s/\n\n/\n/

> +	if (missed) {
> +		if (time)
> +			missed /= (long)time;
> +
> +		pr_info("Total iterations per millisec: %ld\n", hit + missed);
> +
> +		avg = 1000000 / (hit + missed);

s/1000000/USEC_PER_SEC/?

Hopefully we can't have hit+missed==0.

They're counters and hence should have unsigned types.

But even unsigned up-counters can add to zero if wrapping occurs.


> +		pr_info("%ld ns per entry\n", avg);
> +	}
>  }
