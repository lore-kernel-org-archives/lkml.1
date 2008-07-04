Return-Path: <linux-kernel-owner+w=401wt.eu-S1756763AbYGDIdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763AbYGDIdI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 04:33:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbYGDIc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 04:32:56 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:36832 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751844AbYGDIcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 04:32:55 -0400
Date: Fri, 4 Jul 2008 17:29:59 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Uwe Kleine-K?nig <Uwe.Kleine-Koenig@digi.com>
Cc: Magnus Damm <magnus.damm@gmail.com>, "Hans J. Koch" <hjk@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH] uio: User IRQ Mode
Message-ID: <20080704082959.GA9442@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Uwe Kleine-K?nig <Uwe.Kleine-Koenig@digi.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	"Hans J. Koch" <hjk@linutronix.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>
References: <20080702105951.22648.2197.sendpatchset@rx1.opensource.se> <20080702125400.GC3199@local> <20080703071019.GC12214@digi.com> <20080703124505.GB3197@local> <aec7e5c30807032103p7626dcbdwe06c5fac461372c1@mail.gmail.com> <20080704060108.GA11794@digi.com> <aec7e5c30807040048yd8543d4n2edba43524279b6f@mail.gmail.com> <20080704081125.GA26703@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080704081125.GA26703@digi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2008 at 10:11:25AM +0200, Uwe Kleine-K?nig wrote:
> Magnus Damm wrote:
> > > Maybe it's sensible to add the User IRQ Mode functions at least for now
> > > into platform code.  Then at a later time if and when there are several
> > > copies the discussion to move it to the generic part might be easier.
> > 
> > Do you mean your uio_pdrv driver?
> No, I don't.  I meant arch/whatever/...
> 
Placing it in arch/ makes no sense, as there is nothing platform or
architecture specific about it. It is a generic bit of functionality that
various platforms may or may not want to enable, it should be reflected
in UIO directly and simply enabled by those that care. Copying it around
all over the place to make up for the fact the UIO people don't want to
take patches is not a solution.

> If you want to add it to uio_pdrv you either have to introduce a new
> header file or you need to add it to uio_driver.h.  IMHO the first is
> ugly and I'm sure Hans will object the latter.
> 
I'm sure Hans will object to pretty much any UIO patch that adds
functionality he didn't envision from the beginning, but that doesn't
justify burying this crap in the architecture code. Likewise, without any
serious technical objections to the user IRQ mode, it's also difficult to
care. So far all of the technical issues raised in this thread and the
ones before it have all been readily addressed, and I'm unaware of any
outstanding issues here.

Having said that, it would be nice to respin this encapsulating your
rewrite of the commit log so there's less confusion, and then see about
having Greg or Andrew merge this. The patch can easily be reworked if
anyone else raises any technical concerns about this particular approach.
