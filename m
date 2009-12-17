Return-Path: <linux-kernel-owner+w=401wt.eu-S1764948AbZLQUot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764948AbZLQUot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 15:44:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764834AbZLQUor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 15:44:47 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:53975 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762699AbZLQUoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 15:44:46 -0500
Date: Thu, 17 Dec 2009 14:43:33 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [this_cpu_xx V7 0/8] Per cpu atomics in core allocators and
 cleanup
In-Reply-To: <20091217202558.GA21713@Krystal>
Message-ID: <alpine.DEB.2.00.0912171443080.5819@router.home>
References: <20091214220320.665065925@quilx.com> <20091215174302.GA3928@Krystal> <4B2830CC.7040309@kernel.org> <20091216014031.GA12282@Krystal> <4B283BFE.2040005@kernel.org> <20091217133958.GA21618@Krystal> <alpine.DEB.2.00.0912171327220.3638@router.home>
 <20091217202558.GA21713@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Dec 2009, Mathieu Desnoyers wrote:

> Some quick test on my Intel Xeon E5405:
>
> local cmpxchg:  14 cycles
> xchg:           18 cycles
>
> So yes, indeed, the non-LOCK prefixed local cmpxchg seems a bit faster
> than the xchg, given the latter has an implied LOCK prefix.
>
> Code used for local cmpxchg:
>                 old = var;
>                 do {
>                         ret = cmpxchg_local(&var, old, 4);
>                         if (likely(ret == old))
>                                 break;
>                         old = ret;
>                 } while (1);
>

Great. Could you also put that into "patch-format"?

