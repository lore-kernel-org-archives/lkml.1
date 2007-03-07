Return-Path: <linux-kernel-owner+w=401wt.eu-S1030751AbXCGAFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030751AbXCGAFM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 19:05:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030752AbXCGAFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 19:05:11 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39420
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1030751AbXCGAFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 19:05:10 -0500
Date: Tue, 06 Mar 2007 16:05:07 -0800 (PST)
Message-Id: <20070306.160507.88477212.davem@davemloft.net>
To: shemminger@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] div64_64 support
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070306160055.48b201a4@freekitty>
References: <20070306215349.hquin7d6pfy2n5d2@m.safari.iki.fi>
	<20070306222435.cbpv63ltximq6lrf@m.safari.iki.fi>
	<20070306160055.48b201a4@freekitty>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@linux-foundation.org>
Date: Tue, 6 Mar 2007 16:00:55 -0800

> On Wed, 7 Mar 2007 00:24:35 +0200
> Sami Farin <7atbggg02@sneakemail.com> wrote:
> 
> > On Tue, Mar 06, 2007 at 23:53:49 +0200, Sami Farin wrote:
> > ...
> > > And I found bug in gcc-4.1.2, it gave 0 for ncubic results
> > > when doing 1000 loops test... gcc-4.0.3 works.
> > 
> > Found it.
> > 
> > --- cbrt-test.c~	2007-03-07 00:20:54.735248105 +0200
> > +++ cbrt-test.c	2007-03-07 00:21:03.964864343 +0200
> > @@ -209,7 +209,7 @@
> >  
> >  	__asm__("bsrl %1,%0\n\t"
> >  		"cmovzl %2,%0"
> > -		: "=&r" (r) : "rm" (x), "rm" (-1));
> > +		: "=&r" (r) : "rm" (x), "rm" (-1) : "memory");
> >  	return r+1;
> >  }
> >  
> > Now Linux 2.6 does not have "memory" in fls, maybe it causes
> > some gcc funnies some people are seeing.
> > 
> 
> That code was copy-paste from:
> 	include/asm-x86_64/bitops.h
> 
> So shouldn't both fls() and ffs() be fixed there as well?

This code doesn't modify memory behind gcc's back, so this
"memory" clobber shouldn't really be needed.
