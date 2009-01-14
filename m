Return-Path: <linux-kernel-owner+w=401wt.eu-S1761499AbZANJqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761499AbZANJqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 04:46:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755690AbZANJqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 04:46:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54570 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754163AbZANJqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 04:46:34 -0500
Date: Wed, 14 Jan 2009 10:45:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tejun Heo <tj@kernel.org>, Brian Gerst <brgerst@gmail.com>,
       ebiederm@xmission.com, cl@linux-foundation.org, rusty@rustcorp.com.au,
       travis@sgi.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       steiner@sgi.com, hugh@veritas.com
Subject: Re: [patch] add optimized generic percpu accessors
Message-ID: <20090114094546.GA29776@elte.hu>
References: <1231843097-18003-1-git-send-email-tj@kernel.org> <496C717F.70204@kernel.org> <73c1f2160901130527s2d61f4ewf0725c3bf1b36a1a@mail.gmail.com> <496C9FB7.9050907@kernel.org> <496D8CEB.5060402@zytor.com> <20090114093834.GA19799@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114093834.GA19799@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4844]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> Tejun, could you please also add the patch below to your lineup too?
> 
> It is an optimization and a cleanup, and adds the following new generic 
> percpu methods:
> 
>   percpu_read()
>   percpu_write()
>   percpu_add()
>   percpu_sub()
>   percpu_or() 
>   percpu_xor()
> 
> and implements support for them on x86. (other architectures will fall 
> back to a default implementation)

btw., this patch means that we can move Brian's original PDA cleanups 
fully and without kernel size bloat: instead of pda_read() we can use 
percpu_read(), and not bloat the kernel at all.

and thus the pda ops can go away completely.

	Ingo
