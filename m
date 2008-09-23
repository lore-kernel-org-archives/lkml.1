Return-Path: <linux-kernel-owner+w=401wt.eu-S1751835AbYIWL3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835AbYIWL3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 07:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750829AbYIWL3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 07:29:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47063 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806AbYIWL3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 07:29:00 -0400
Date: Tue, 23 Sep 2008 13:28:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Srinivasa Ds <srinivasa@in.ibm.com>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, paulus@samba.org, linuxppc-dev@ozlabs.org,
       linux-parisc@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH] Demultiplexing SIGTRAP signal
Message-ID: <20080923112812.GL29021@elte.hu>
References: <200809221602.32616.srinivasa@in.ibm.com> <200809221841.27993.srinivasa@in.ibm.com> <20080922145404.GC27956@elte.hu> <200809231523.52802.srinivasa@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809231523.52802.srinivasa@in.ibm.com>
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


* Srinivasa Ds <srinivasa@in.ibm.com> wrote:

> On Monday 22 September 2008 20:24:04 Ingo Molnar wrote:
> > * Srinivasa Ds <srinivasa@in.ibm.com> wrote:
> > > --- linux-2.6.27-rc7.orig/arch/ia64/include/asm/siginfo.h
> > > +++ linux-2.6.27-rc7/arch/ia64/include/asm/siginfo.h
> >
> > please do not send patches that modify include/asm/ files, the
> > include/asm-x86/ file should be modified instead.
> >
> > (this problem will go away in v2.6.28 when we'll move include/asm-x86/
> > to arch/x86/include/)
> >
> 
> Ingo, Sorry if I have confused you. [...]

hah, indeed - i mis-read them as include/asm/.

> Currently a SIGTRAP can denote any one of below reasons.
> 	- Breakpoint hit
> 	- H/W debug register hit
> 	- Single step
> 	- Signal sent through kill() or rasie()
> 
> Architectures like powerpc/parisc provides infrastructure to 
> demultiplex SIGTRAP signal by passing down the information for 
> receiving SIGTRAP through si_code of siginfot_t structure. Here is an 
> attempt is generalise this infrastructure by extending it to x86 and 
> x86_64 archs.

applied to [the new topic] tip/core/signal, thanks Srinivasa! There are 
some other pending x86 signal changes already, so i based 
tip/core/signal on tip/x86/signal.

Roland, any opinion on this change?

	Ingo
