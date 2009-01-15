Return-Path: <linux-kernel-owner+w=401wt.eu-S1763649AbZAOLdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763649AbZAOLdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 06:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbZAOLdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 06:33:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41600 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448AbZAOLdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 06:33:09 -0500
Date: Thu, 15 Jan 2009 12:32:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: roel kluin <roel.kluin@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Brian Gerst <brgerst@gmail.com>, ebiederm@xmission.com,
       cl@linux-foundation.org, rusty@rustcorp.com.au, travis@sgi.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       steiner@sgi.com, hugh@veritas.com
Subject: Re: [patch] add optimized generic percpu accessors
Message-ID: <20090115113230.GH22850@elte.hu>
References: <1231843097-18003-1-git-send-email-tj@kernel.org> <496C717F.70204@kernel.org> <73c1f2160901130527s2d61f4ewf0725c3bf1b36a1a@mail.gmail.com> <496C9FB7.9050907@kernel.org> <496D8CEB.5060402@zytor.com> <20090114093834.GA19799@elte.hu> <25e057c00901150204x61c54d9fl91afe23477d1f12f@mail.gmail.com> <496F0F5E.3080404@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496F0F5E.3080404@kernel.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> roel kluin wrote:
> >> Index: linux/include/asm-generic/percpu.h
> >> ===================================================================
> >> --- linux.orig/include/asm-generic/percpu.h
> >> +++ linux/include/asm-generic/percpu.h
> >> @@ -80,4 +80,32 @@ extern void setup_per_cpu_areas(void);
> >>  #define DECLARE_PER_CPU(type, name) extern PER_CPU_ATTRIBUTES \
> >>                                        __typeof__(type) per_cpu_var(name)
> >>
> >> +/*
> >> + * Optional methods for optimized non-lvalue per-cpu variable access:
> >> + */
> >> +
> >> +#ifndef percpu_read
> >> +# define percpu_read(var)              __get_cpu_var(var)
> >> +#endif
> >> +
> >> +#ifndef percpu_write
> >> +# define percpu_write(var, val)                ({ __get_cpu_var(var) = (val); })
> >> +#endif
> >> +
> >> +#ifndef percpu_add
> >> +# define percpu_add(var, val)          ({ __get_cpu_var(var) += (val); })
> >> +#endif
> >> +
> >> +#ifndef percpu_sub
> >> +# define percpu_add(var, val)          ({ __get_cpu_var(var) += (val); })
> > 
> > this should be:
> > 
> > define percpu_sub(var, val)          ({ __get_cpu_var(var) -= (val); })

well spotted!

> Thanks.  Will fold into the patch.

thanks!

Is there any interim tree for us to pull into -tip? I'd rather not let 
this grow too big, it will be harder and harder to debug any regressions. 
Gradual progress is a lot more debuggable. Your initial patchset is 
fantastic already (gives a ~0.2% kernel image size saving for defconfig), 
so it's a very good start.

	Ingo
