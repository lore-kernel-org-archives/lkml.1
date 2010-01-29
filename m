Return-Path: <linux-kernel-owner+w=401wt.eu-S1756883Ab0A2KCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab0A2KCL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 05:02:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754979Ab0A2KCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 05:02:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32869 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754706Ab0A2KCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 05:02:08 -0500
Date: Fri, 29 Jan 2010 02:01:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu
Cc: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       eranian@google.com, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
Subject: Re: [tip:perf/core] bitops: Provide compile time
 HWEIGHT{8,16,32,64}
Message-Id: <20100129020128.716af8fb.akpm@linux-foundation.org>
In-Reply-To: <tip-9f41699ed067fa695faff8e2e9981b2550abec62@git.kernel.org>
References: <20100122155535.797688466@chello.nl>
	<tip-9f41699ed067fa695faff8e2e9981b2550abec62@git.kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jan 2010 09:28:04 GMT tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> +#define HWEIGHT8(w)			\
> +      (	(!!((w) & (1ULL << 0))) +	\
> +	(!!((w) & (1ULL << 1))) +	\
> +	(!!((w) & (1ULL << 2))) +	\
> +	(!!((w) & (1ULL << 3))) +	\
> +	(!!((w) & (1ULL << 4))) +	\
> +	(!!((w) & (1ULL << 5))) +	\
> +	(!!((w) & (1ULL << 6))) +	\
> +	(!!((w) & (1ULL << 7)))	)
> +
> +#define HWEIGHT16(w) (HWEIGHT8(w)  + HWEIGHT8(w >> 8))
> +#define HWEIGHT32(w) (HWEIGHT16(w) + HWEIGHT16(w >> 16))
> +#define HWEIGHT64(w) (HWEIGHT32(w) + HWEIGHT32(w >> 32))

Would be nice if it had a comment explaining why it exists.  If people
accidentally use this with non-constant arguments, the generated code
will be pretty ghastly.

Or add some barf-if-not-__constant_p() thing, perhaps.
