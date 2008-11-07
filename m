Return-Path: <linux-kernel-owner+w=401wt.eu-S1753162AbYKGIxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbYKGIxH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 03:53:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbYKGIwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 03:52:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60122 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750879AbYKGIwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 03:52:54 -0500
Date: Fri, 7 Nov 2008 00:52:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Mike Travis <travis@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpumask: introduce new API, without changing anything
Message-Id: <20081107005229.53d6f2e3.akpm@linux-foundation.org>
In-Reply-To: <20081107084016.GF4435@elte.hu>
References: <20081029152849.3883d072.sfr@canb.auug.org.au>
	<200811021229.16061.rusty@rustcorp.com.au>
	<alpine.LFD.2.00.0811011834360.3483@nehalem.linux-foundation.org>
	<200811070949.02914.rusty@rustcorp.com.au>
	<20081107084016.GF4435@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Nov 2008 09:40:16 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> +#if NR_CPUS == 1
> +/* Uniprocesor. */
> +#define cpumask_first(src)		({ (void)(src); 0; })
>
> ...
>
> +#else
> +static inline unsigned int cpumask_first(const struct cpumask *srcp)
> +{
> +	return find_first_bit(cpumask_bits(srcp), nr_cpumask_bits);
> +}
>
> ...
>
> +#endif /* SMP */

So I can happily compile and run

	cpumask_first("hello, world");

with CONFIG_SMP=n?

