Return-Path: <linux-kernel-owner+w=401wt.eu-S1756154AbZA0VGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbZA0VGF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 16:06:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750898AbZA0VFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 16:05:50 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:57902 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751178AbZA0VFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 16:05:49 -0500
Date: Tue, 27 Jan 2009 15:08:57 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Tejun Heo <tj@kernel.org>
cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Herbert Xu <herbert@gondor.apana.org.au>, akpm@linux-foundation.org,
       hpa@zytor.com, brgerst@gmail.com, ebiederm@xmission.com, travis@sgi.com,
       linux-kernel@vger.kernel.org, steiner@sgi.com, hugh@veritas.com,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH] percpu: add optimized generic percpu accessors
In-Reply-To: <497E705B.5000302@kernel.org>
Message-ID: <alpine.DEB.1.10.0901271506580.3114@qirst.com>
References: <20090115183942.GA6325@elte.hu> <200901201328.24605.rusty@rustcorp.com.au> <49756E6E.2060409@kernel.org> <200901271213.18605.rusty@rustcorp.com.au> <497E705B.5000302@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2009, Tejun Heo wrote:

> > later). That's because they use TLB tricks for a static 64k per-cpu
> > area, but this doesn't scale.  That might not be vital: abandoning
> > that trick will mean they can't optimise read_percpu/read_percpu_var
> > etc as much.

Why wont it scale? this is a separate TLB entry for each processor.

>
> Isn't something like the following possible?
>
> #define pcpu_read(ptr)						\
> ({								\
> 	if (__builtin_constant_p(ptr) &&			\
> 	    ptr >= PCPU_STATIC_START && ptr < PCPU_STATIC_END)	\
> 		do 64k TLB trick for static pcpu;		\
> 	else							\
> 		do generic stuff;				\
> })

The TLB trick is just to access the percpu data at a fixed base. I.e.
	value = SHIFT_PERCPU_PTR(percpu_var, FIXED_ADDRESS);

