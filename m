Return-Path: <linux-kernel-owner+w=401wt.eu-S935237AbXJSJal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935237AbXJSJal (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 05:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbXJSJac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 05:30:32 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:1964 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755982AbXJSJab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 05:30:31 -0400
Date: Fri, 19 Oct 2007 17:29:21 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       akpm@linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org
Subject: Re: [NET]: Fix possible dev_deactivate race condition
Message-ID: <20071019092921.GA12380@gondor.apana.org.au>
References: <1192745137.7367.40.camel@pasglop> <alpine.LFD.0.999.0710181549330.26902@woody.linux-foundation.org> <1192749449.7367.51.camel@pasglop> <alpine.LFD.0.999.0710181627091.26902@woody.linux-foundation.org> <20071019023219.GB8453@gondor.apana.org.au> <alpine.LFD.0.999.0710181941020.26902@woody.linux-foundation.org> <alpine.LFD.0.999.0710182007170.26902@woody.linux-foundation.org> <20071019042025.GA9617@gondor.apana.org.au> <20071019053624.GA10560@gondor.apana.org.au> <1192779319.27435.163.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1192779319.27435.163.camel@twins>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2007 at 09:35:19AM +0200, Peter Zijlstra wrote:
>
> >         /* Wait for outstanding qdisc_run calls. */
> > -       while (test_bit(__LINK_STATE_QDISC_RUNNING, &dev->state))
> > -               yield();
> > +       do {
> > +               while (test_bit(__LINK_STATE_QDISC_RUNNING, &dev->state))
> > +                       yield();
> > +
> 
> Ouch!, is there really no sane locking alternative? Hashed waitqueues
> like for the page lock come to mind.

Well if we ever moved the transmission to full process context
then we'll gladly accept your patch :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
