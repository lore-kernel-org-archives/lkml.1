Return-Path: <linux-kernel-owner+w=401wt.eu-S1756449AbXJJQSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449AbXJJQSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 12:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754878AbXJJQSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 12:18:07 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53119 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753AbXJJQSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 12:18:05 -0400
Subject: Re: [v4l-dvb-maintainer] [PATCH 3/3] V4L: cinergyT2, remove bad
	usage of ERESTARTSYS
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Alan Cox <alan@redhat.com>
Cc: Michael Krufky <mkrufky@linuxtv.org>, video4linux-list@redhat.com,
       Jiri Slaby <jirislaby@gmail.com>, daniel@qanu.de,
       linux-kernel@vger.kernel.org, holger@qanu.de,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20071010155920.GC22618@devserv.devel.redhat.com>
References: <24841282012868130110@pripojeni.net>
	 <1191979260.5492.32.camel@gaivota> <470C5294.8060502@linuxtv.org>
	 <1192030541.5896.54.camel@gaivota>
	 <20071010155920.GC22618@devserv.devel.redhat.com>
Content-Type: text/plain; charset=utf-8
Date: Wed, 10 Oct 2007 13:17:50 -0300
Message-Id: <1192033070.5896.77.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Em Qua, 2007-10-10 às 11:59 -0400, Alan Cox escreveu:
> On Wed, Oct 10, 2007 at 12:35:41PM -0300, Mauro Carvalho Chehab wrote:
> > Em Qua, 2007-10-10 às 00:18 -0400, Michael Krufky escreveu:
> > > 
> > > Is this illegal as per kernel codingstyle?
> > 
> > Yes, it is. CodingStyle states:
> 
> <rant>
> No.. "Illegal" means prohibited by law. Its merely wrong 8)
> </rant>

LOL

> > The proper fix is just to replace the offended code by this:
> > 
> > err=foo();
> > if (error)
> > 	goto error;
> 
> Lots of code uses
> 
> 	if ((err = foo()) < 0)
> 
> so I would'y worry too much. The split one however clearer and also
> safer.

Yes, this is not a severe CodingStyle violation. Still, the above code
is better than the used one.

Since, on your example, it is clear that the programmer wanted to test
if the value is less than zero. 

The code:

	if ( (err=foo()) )

should also indicate an operator mistake of using =, instead of ==.

Probably, source code analyzers like Coverity will complain about the
above.

If not violating CodingStyle, I would rather prefer to code this as:
	if ( !(err=foo() ) 
or, even better, using:
	if ( (err=foo()) != 0)

clearly indicating that it is tested if the value is not zero.

Even being a quite simple issue, I would prefer if Jiri can fix it.

-- 
Cheers,
Mauro

