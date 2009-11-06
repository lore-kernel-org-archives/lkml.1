Return-Path: <linux-kernel-owner+w=401wt.eu-S1759501AbZKFRIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759501AbZKFRIA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 12:08:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759364AbZKFRH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 12:07:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50274 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759359AbZKFRH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 12:07:58 -0500
Message-ID: <4AF457E0.4040107@zytor.com>
Date: Fri, 06 Nov 2009 09:07:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: ling.ma@intel.com
CC: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] [X86] performance improvement for memcpy_64.S by
 fast string.
References: <1257500482-16182-1-git-send-email-ling.ma@intel.com>
In-Reply-To: <1257500482-16182-1-git-send-email-ling.ma@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2009 01:41 AM, ling.ma@intel.com wrote:
> 
>  Performance counter stats for './static_orig' (10 runs):
> 
>     2835.650105  task-clock-msecs         #      0.999 CPUs    ( +-   0.051% )
>               3  context-switches         #      0.000 M/sec   ( +-   6.503% )
>               0  CPU-migrations           #      0.000 M/sec   ( +-     nan% )
>            4429  page-faults              #      0.002 M/sec   ( +-   0.003% )
>      7941098692  cycles                   #   2800.451 M/sec   ( +-   0.051% )
>     10848100323  instructions             #      1.366 IPC     ( +-   0.000% )
>          322808  cache-references         #      0.114 M/sec   ( +-   1.467% )
>          280716  cache-misses             #      0.099 M/sec   ( +-   0.618% )
> 
>     2.838006377  seconds time elapsed   ( +-   0.051% )
> 
> 'perf stat --repeat 10 ./static_new' command get data after patch:
> 
>  Performance counter stats for './static_new' (10 runs):
> 
>     7401.423466  task-clock-msecs         #      0.999 CPUs    ( +-   0.108% )
>              10  context-switches         #      0.000 M/sec   ( +-   2.797% )
>               0  CPU-migrations           #      0.000 M/sec   ( +-     nan% )
>            4428  page-faults              #      0.001 M/sec   ( +-   0.003% )
>     20727280183  cycles                   #   2800.445 M/sec   ( +-   0.107% )
>      1472673654  instructions             #      0.071 IPC     ( +-   0.013% )
>         1092221  cache-references         #      0.148 M/sec   ( +-  12.414% )
>          290550  cache-misses             #      0.039 M/sec   ( +-   1.577% )
> 
>     7.407006046  seconds time elapsed   ( +-   0.108% )
> 

I assume these are backwards?  If so, it's a dramatic performance
improvement.

Where did the 1024 byte threshold come from?  It seems a bit high to me,
and is at the very best a CPU-specific tuning factor.

Andi is of course correct that older CPUs might suffer (sadly enough),
which is why we'd at the very least need some idea of what the
performance impact on those older CPUs would look like -- at that point
we can make a decision to just unconditionally do the rep movs or
consider some system where we point at different implementations for
different processors -- memcpy is probably one of the very few
operations for which something like that would make sense.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

