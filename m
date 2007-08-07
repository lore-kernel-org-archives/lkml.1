Return-Path: <linux-kernel-owner+w=401wt.eu-S1758252AbXHGIXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758252AbXHGIXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 04:23:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbXHGIWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 04:22:55 -0400
Received: from mx10.go2.pl ([193.17.41.74]:46020 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753724AbXHGIWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 04:22:52 -0400
Date: Tue, 7 Aug 2007 10:23:21 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Marcin =?iso-8859-2?Q?=A6lusarz?= <marcin.slusarz@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jean-Baptiste Vignaud <vignaud@xandmail.fr>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       shemminger <shemminger@linux-foundation.org>,
       linux-net <linux-net@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2.6.20->2.6.21 - networking dies after random time
Message-ID: <20070807082321.GB2120@ff.dom.local>
References: <20070726081326.GA3197@ff.dom.local> <1185437431.3227.21.camel@chaos> <20070726083120.GA26910@elte.hu> <20070726085523.GA3423@ff.dom.local> <20070726091254.GA8063@elte.hu> <4bacf17f0707300029g5116e70bq4808059dc8b069f1@mail.gmail.com> <20070731132037.GC1046@ff.dom.local> <4bacf17f0708060000n5a00bb77i74adc3b4b28ac42b@mail.gmail.com> <20070806070300.GA4509@elte.hu> <4bacf17f0708070046o14403089v8376a4544f72fec3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4bacf17f0708070046o14403089v8376a4544f72fec3@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2007 at 09:46:36AM +0200, Marcin ¦lusarz wrote:
> 2007/8/6, Ingo Molnar <mingo@elte.hu>:
> > (..)
> > please try Jarek's second patch too - there was a missing unmask.
> >
> >         Ingo
> >
> > -------------->
> > Subject: genirq: fix simple and fasteoi irq handlers
> > From: Jarek Poplawski <jarkao2@o2.pl>
...
> Network card still locks up (tested on 2.6.22.1). I had to upload more
> data than usual (~350 MB vs ~1-100 MB) to trigger that bug but it
> might be a coincidence...

Thanks! It's a good news after all - it would be really strange why
this place doesn't hit more people (it seems there is some safety
elsewhere for this).

BTW: I hope, this previous Thomas' patch with Ingo's warning to resend.c
(with a warning), had no problems with a similar load?

So, once more, I would suspect hw retrigger code. Ingo, IMHO, this
patch for testing HARDIRQS_SW_RESEND could be reworked, so that
desc->chip->retrigger() is done only for eadges and the tasklet only
for levels. BTW, I think this current warning in the "temporary" is
is too early - we don't know if after this the ->retrigger() will
take place.

Regards,
Jarek P.

PS: Marcin, if you need a break in this testing let us know!
I think the main idea of this bug is known enough.
