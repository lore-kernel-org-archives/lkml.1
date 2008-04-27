Return-Path: <linux-kernel-owner+w=401wt.eu-S1762811AbYD0WmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762811AbYD0WmR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 18:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbYD0WmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 18:42:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60853 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbYD0WmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 18:42:03 -0400
Date: Mon, 28 Apr 2008 00:41:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch] x86, voyager: fix ioremap_nocache()
Message-ID: <20080427224150.GA12238@elte.hu>
References: <1209329485.3801.46.camel@localhost.localdomain> <20080427214837.GA11631@elte.hu> <1209333959.3801.67.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209333959.3801.67.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> >  		request_resource(&iomem_resource, &res);
> >  		voyager_SUS = (struct voyager_SUS *)
> > -		    ioremap(addr, 0x400);
> > +		    ioremap_cache(addr, 0x400);
> 
> Actually, no ... wrong ioremap.  That one is the SUS clickmap remap, 
> which is irrelevant whether it's cached or not. The QIC cacheline area 
> is the next one below it.

yes, but i assumed that since you had all cached ioremaps before, you 
might wanted it for all of the devices in voyager_cat.c (or at least it 
wouldnt hurt). Btw., the QIC ioremap i changed in my patch too, just in 
case you didnt notice:

> > -               qic_addr = (unsigned long)ioremap(qic_addr, 0x400);
> > +               qic_addr = (unsigned long)ioremap_cache(qic_addr, 0x400);

so my patch too should do the trick.

	Ingo
