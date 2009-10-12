Return-Path: <linux-kernel-owner+w=401wt.eu-S1757522AbZJLSZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522AbZJLSZA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 14:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757414AbZJLSY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 14:24:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53718 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757430AbZJLSY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 14:24:58 -0400
Date: Mon, 12 Oct 2009 20:23:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] panic.c: export panic_on_oops
Message-ID: <20091012182346.GH17138@elte.hu>
References: <20091012113758.GB11035@elte.hu> <20091012140149.6789efab@marrow.netinsight.se> <20091012120951.GA16799@elte.hu> <1255349748.10605.13.camel@macbook.infradead.org> <20091012122023.GA19365@elte.hu> <20091012150650.51a4b4dc@marrow.netinsight.se> <20091012131528.GC25464@elte.hu> <20091012153937.0dcd73e5@marrow.netinsight.se> <alpine.LFD.2.01.0910120828390.3438@localhost.localdomain> <20091012110954.67d7d8d8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012110954.67d7d8d8.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 12 Oct 2009 08:36:38 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > I agree with the "save kernel buffer on panic" thing, but I disagree with 
> > making it anything new, and hooking into "printk()" or the console 
> > subsystem AT ALL. That's just bogus, stupid, and WRONG.
> > 
> > What you can do is to just flush the 'log_buf' buffer (or as much of it as 
> > you want - the buffer may be a megabyte in size, and maybe you only want 
> > to flush the last 8kB or something like that) on oops. And _not_ mix this 
> > up with anything else.
> 
> What he said.  I did it that way in the Digeo kernel back in 2002. 
> Worked good.
> 
> Doing it via a console is rather weird.  It will need core kernel 
> changes to do it properly.
> 
> Perhaps oops_enter() is a good place to mark the start of the log, and 
> flush it within oops_exit().

Simplest would be to do the last 2K in oops_exit()? That gives the oops, 
and the history leading up to it. Since the blocking is 2K, the extra 
log output is for free.

(unless the oops is larger than 2K - but that is rather rare.)

	Ingo
