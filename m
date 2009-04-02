Return-Path: <linux-kernel-owner+w=401wt.eu-S1764825AbZDBWZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764825AbZDBWZa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 18:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759974AbZDBWZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 18:25:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59504 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759731AbZDBWZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 18:25:14 -0400
Date: Fri, 3 Apr 2009 00:23:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, rusty@rustcorp.com.au,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] - Updated: Fix slab corruption caused by
	alloc_cpumask_var_node()
Message-ID: <20090402222359.GE9239@elte.hu>
References: <20090402212751.GA11495@sgi.com> <20090402143932.79a15852.akpm@linux-foundation.org> <20090402220900.GA15129@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090402220900.GA15129@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jack Steiner <steiner@sgi.com> wrote:

> Fix slab corruption caused by alloc_cpumask_var_node() overwriting
> the tail end of an off-stack cpumask.
> 
> The function zeros out cpumask bits beyond the last possible cpu.
> The starting point for zeroing should be the beginning
> of the mask offset by a byte count derived from the number
> of possible cpus. The offset was calculated in bits instead of bytes.
> This resulted in overwriting the end of the cpumask.
> 
> 
> v2.6.29 is also affected by this bug.
> 
> 
> Signed-off-by: Jack Steiner <steiner@sgi.com>
> Acked-by: Mike Travis <travis.sgi.com>
> Acked-by: Ingo Molnar <mingo@elte.hu>

In the future you can add:

  Cc: <stable@kernel.org>

to the signoff/ack section of the changlog in such cases - then the 
-stable folks will notice the commit automatically.

Thanks,

	Ingo
