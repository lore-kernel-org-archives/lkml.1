Return-Path: <linux-kernel-owner+w=401wt.eu-S1760026AbZATKlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760026AbZATKlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 05:41:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755809AbZATKlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 05:41:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51710 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752684AbZATKlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 05:41:02 -0500
Date: Tue, 20 Jan 2009 11:40:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, akpm@linux-foundation.org,
       tj@kernel.org, hpa@zytor.com, brgerst@gmail.com, ebiederm@xmission.com,
       cl@linux-foundation.org, travis@sgi.com, linux-kernel@vger.kernel.org,
       steiner@sgi.com, hugh@veritas.com,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH] percpu: add optimized generic percpu accessors
Message-ID: <20090120104022.GB29346@elte.hu>
References: <20090115183942.GA6325@elte.hu> <200901170827.33729.rusty@rustcorp.com.au> <20090116220832.GB20653@elte.hu> <200901201328.24605.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901201328.24605.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Saturday 17 January 2009 08:38:32 Ingo Molnar wrote:
> > How do difficulties of dynamic percpu-alloc make my above suggestion 
> > unsuitable for SNMP stats in networking? Most of those stats are not 
> > dynamically allocated - they are plain straightforward percpu variables.
> 
> No they're not. [...]

hm, i see this got changed recently - part of the networking stats went 
over to the lib/percpu_counter API recently.

The larger point still remains: the kernel dominantly uses static percpu 
variables by a margin of 10 to 1, so we cannot just brush away the static 
percpu variables and must concentrate on optimizing that side with 
priority. It's nice if the dynamic percpu-alloc side improves as well, of 
course.

	Ingo
