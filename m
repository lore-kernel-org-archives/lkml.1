Return-Path: <linux-kernel-owner+w=401wt.eu-S1758786AbYGAUET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758786AbYGAUET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 16:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754355AbYGAUEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 16:04:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59258 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802AbYGAUEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 16:04:05 -0400
Date: Tue, 1 Jul 2008 22:03:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Abhishek Sagar <sagar.abhishek@gmail.com>
Cc: David Miller <davem@davemloft.net>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org, sparclinux@vger.kernel.org,
       rostedt@goodmis.org
Subject: Re: next-0630: sparc64: build failed
Message-ID: <20080701200344.GA4896@elte.hu>
References: <a4423d670807010825t7ea2eb44oda3f08dc007c40a2@mail.gmail.com> <20080701154648.GA31057@elte.hu> <486A7C19.5080905@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486A7C19.5080905@gmail.com>
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


* Abhishek Sagar <sagar.abhishek@gmail.com> wrote:

> Hi Ingo/David,
> 
> CONFIG_MCOUNT currently controls the compilation with -pg flag and the 
> export of _mcount. But with ftrace, the former is redundant and the 
> latter should be made unconditional since _mcount is always defined. 
> In which case, does the inlined patch (untested) make sense? It should 
> solve the build failure as well.

hm, mcount is the facility - so it makes sense to have that defined. 
Here you basically hide CONFIG_MCOUNT:

> -ifeq ($(CONFIG_MCOUNT),y)
> -  KBUILD_CFLAGS += -pg
> +ifneq ($(CONFIG_FTRACE),y)
> +ifeq ($(CONFIG_STACK_DEBUG),y)
> +KBUILD_CFLAGS += -pg
> +endif
>  endif

via two conditions. I'm not sure that's a win and i found CONFIG_MCOUNT 
a logical switch - but it's David's call.

	Ingo
