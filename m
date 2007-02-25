Return-Path: <linux-kernel-owner+w=401wt.eu-S965021AbXBYR37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965021AbXBYR37 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 12:29:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965026AbXBYR37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 12:29:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39329 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965021AbXBYR36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 12:29:58 -0500
Date: Sun, 25 Feb 2007 18:23:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070225172337.GB4998@elte.hu>
References: <20070221211355.GA7302@elte.hu> <20070224183421.GA6835@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070224183421.GA6835@2ka.mipt.ru>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:

> On Wed, Feb 21, 2007 at 10:13:55PM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> > this is the v3 release of the syslet/threadlet subsystem:
> > 
> >    http://redhat.com/~mingo/syslet-patches/
> 
> There is no %xgs.
> 
> --- ./arch/i386/kernel/process.c~	2007-02-24 22:56:14.000000000 +0300
> +++ ./arch/i386/kernel/process.c	2007-02-24 22:53:19.000000000 +0300
> @@ -426,7 +426,6 @@
>  
>  	regs.xds = __USER_DS;
>  	regs.xes = __USER_DS;
> -	regs.xgs = __KERNEL_PDA;

hm, what tree are you using as a base? The syslet patches are against 
v2.6.20 at the moment. (the x86 PDA changes will probably interfere with 
it on v2.6.21-rc1-ish kernels) Note that otherwise the syslet/threadlet 
patches are for x86 only at the moment (as i mentioned in the 
announcement), and the generic code itself contains some occasional 
x86-ishms as well. (None of the concepts are x86-specific though - 
multi-stack architectures should work just as well as RISC-ish CPUs.)

if you create a threadlet based test-webserver, could you please do a 
comparable kevents implementation as well? I.e. same HTTP parser (or 
non-parser, as usually the case is with prototypes ;). Best would be 
something that one could trigger between threadlet and kevent mode, 
using the same binary :-)

	Ingo
