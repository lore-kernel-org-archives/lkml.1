Return-Path: <linux-kernel-owner+w=401wt.eu-S1757244AbZKWLsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244AbZKWLsv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 06:48:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757055AbZKWLsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 06:48:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53002 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588AbZKWLsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 06:48:50 -0500
Date: Mon, 23 Nov 2009 12:48:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mike Galbraith <efault@gmx.de>, Robert Swan <swan.r.l@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [bisected] pty performance problem
Message-ID: <20091123114845.GC25575@elte.hu>
References: <20091121222319.GA3905@swanrl.gmail.com>
 <20091122063926.GA18224@elte.hu>
 <20091122122312.71a343d9@lxorguk.ukuu.org.uk>
 <1258952431.6261.38.camel@marge.simson.net>
 <20091123113110.15063a0a@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091123113110.15063a0a@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > diff --git a/drivers/char/tty_buffer.c b/drivers/char/tty_buffer.c
> > index 66fa4e1..92a0864 100644
> > --- a/drivers/char/tty_buffer.c
> > +++ b/drivers/char/tty_buffer.c
> > @@ -495,7 +495,7 @@ void tty_flip_buffer_push(struct tty_struct *tty)
> >  	if (tty->low_latency)
> >  		flush_to_ldisc(&tty->buf.work.work);
> >  	else
> > -		schedule_delayed_work(&tty->buf.work, 1);
> > +		schedule_delayed_work(&tty->buf.work, 0);
> >  }
> >  EXPORT_SYMBOL(tty_flip_buffer_push);
> 
> Another possibility is to do
> 
> 	if (tty->low_latency)
> 		schedule_delayed_work(&tty->buf.work, 0);
> 	else
> 		schedule_delayed_work(&tty->buf.work, 1);

Flaggery for low latency is kind of lame though - especially if it 
defaults to off in most drivers as you say.

	Ingo
