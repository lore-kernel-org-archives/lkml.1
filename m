Return-Path: <linux-kernel-owner+w=401wt.eu-S1762734AbYJKU7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762734AbYJKU7e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 16:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283AbYJKU7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 16:59:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58741 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756032AbYJKU7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 16:59:13 -0400
Date: Sat, 11 Oct 2008 22:58:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       torvalds@linux-foundation.org
Subject: Re: Looks broken to me: x86, cyrix: debug
Message-ID: <20081011205858.GA21965@elte.hu>
References: <200810112003.m9BK3Wwu025556@hera.kernel.org> <20081011214043.283a3330@lxorguk.ukuu.org.uk> <alpine.LFD.1.10.0810112146400.1984@ftp.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0810112146400.1984@ftp.linux-mips.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0022]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Maciej W. Rozycki <macro@linux-mips.org> wrote:

> On Sat, 11 Oct 2008, Alan Cox wrote:
> 
> > > +#define getCx86_old(reg) ({ outb((reg), 0x22); inb(0x23); })
> > 
> > Doesn't expand to any kind of returned value.
> 
>  Well, actually it returns the value of the inb() expression -- cf the 
> semantics of compound statements.  The rest looks suspicious indeed.

indeed it's broken - will sort it out. It's all about breakage that has 
been in this code since v2.6.20, see c6744955d0. Will likely revert the 
whole thing.

	Ingo
