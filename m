Return-Path: <linux-kernel-owner+w=401wt.eu-S1756410AbZBEF5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410AbZBEF5z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 00:57:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753506AbZBEF5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 00:57:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:34334 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113AbZBEF5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 00:57:46 -0500
Message-ID: <498A7FD3.5030900@kernel.org>
Date: Thu, 05 Feb 2009 14:57:39 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Cliff Wickman <cpw@sgi.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH v2] x86: UV uv_flush_tlb_others WARN_ON
References: <E1LU7sT-0004ZT-9G@eag09.americas.sgi.com>
In-Reply-To: <E1LU7sT-0004ZT-9G@eag09.americas.sgi.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 05 Feb 2009 05:57:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cliff Wickman wrote:
> From: Cliff Wickman <cpw@sgi.com>
> 
> uv_flush_tlb_others() (arch/x86/kernel/tlb_uv.c)
> The "WARN_ON(!in_atomic())" fails if CONFIG_PREEMPT is not enabled.
> And CONFIG_PREEMPT is not enabled by default in the distribution that
> most UV owners will use.
> 
> We could #ifdef CONFIG_PREEMPT the warning, but that is not good form.
> 
> And there seems to be no suitable fix to in_atomic() when CONFIG_PREMPT
> is not on.
>   As you commented, Ingo:
>   > and we have no proper primitive to test for atomicity. (mainly
>   > because we dont know about atomicity on a non-preempt kernel)
> 
> I propose that we drop the WARN_ON.
> 
> Diffed against 2.6.29-rc2
> 
> Signed-off-by: Cliff Wickman <cpw@sgi.com>

Heh.. I included it in the first two merges but forgot it in the final
round.  Applying to tj-percpu.

Thanks.

-- 
tejun
