Return-Path: <linux-kernel-owner+w=401wt.eu-S1755458AbZFGKUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbZFGKUy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 06:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755054AbZFGKUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 06:20:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50176 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754477AbZFGKUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 06:20:46 -0400
Date: Sun, 7 Jun 2009 12:20:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: cpu_debug.c prepare report if files are
	inappropriate or CPU is not supported
Message-ID: <20090607102036.GO31286@elte.hu>
References: <1239725240.2966.4.camel@ht.satnam> <20090414165052.GA2089@elte.hu> <1239728481.2966.21.camel@ht.satnam> <20090414184222.GC11214@elte.hu> <20090414200247.1d0a8667@lxorguk.ukuu.org.uk> <20090414191622.GA797@elte.hu> <1239773665.15436.9.camel@localhost.localdomain> <20090415101700.GE6669@elte.hu> <1244224637.8212.6.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244224637.8212.6.camel@ht.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> Hello Ingo,
> 
> On Wed, 2009-04-15 at 12:17 +0200, Ingo Molnar wrote:
> 
> > The main beef i had with your code is that it copies CPU enumeration 
> > over into some local variables (cpu_modelflag, cpu_model) with 
> > redundant encodings and decodings which dont fully work.
> > 
> > Is there anything that your encoding/decoding does that cannot be 
> > done via the standard methods?
> > 
> 
> I removed cpu model info. May be this will create some issues on 
> ancient machine as now it depends on rdmsr_safe_on_cpu() and I 
> hope it will be safe ;-)

rdmsr_safe() should really be safe. (If it isnt then that primitive 
needs fixing, not the code that uses it.)

> Can you please check this patch on ancient and latest machines.
> 
> 
> [PATCH] x86: cpu_debug remove model information to reduce encoding-decoding
> 
> Remove model information, encoding/decoding and reduce bookkeeping.
> 
> Reported-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/include/asm/cpu_debug.h |  101 +---------
>  arch/x86/kernel/cpu/cpu_debug.c  |  417 +++++++++-----------------------------
>  2 files changed, 97 insertions(+), 421 deletions(-)

This actually looks like to be a very nice cleanup as well, as can 
be seen from the massive line count reduction. I'll give it some 
testing.

	Ingo
