Return-Path: <linux-kernel-owner+w=401wt.eu-S1754032AbZGMDJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbZGMDJ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 23:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753803AbZGMDJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 23:09:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:49059 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766AbZGMDJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 23:09:55 -0400
Date: Sun, 12 Jul 2009 20:11:21 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>, Siarhei Liakh <sliakh.lkml@gmail.com>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-cris-kernel@axis.com
Subject: Re: [PATCH v5] RO/NX protection for loadable kernel modules
Message-ID: <20090712201121.38990aa5@infradead.org>
In-Reply-To: <200907130851.56161.rusty@rustcorp.com.au>
References: <817ecb6f0907081610p6d60341cudbee42685eac1347@mail.gmail.com>
	<200907121928.28887.rusty@rustcorp.com.au>
	<20090712083227.39939849@infradead.org>
	<200907130851.56161.rusty@rustcorp.com.au>
Organization: Intel
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jul 2009 08:51:55 +0930
Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Mon, 13 Jul 2009 01:02:27 am Arjan van de Ven wrote:
> > Rusty Russell <rusty@rustcorp.com.au> wrote:
> > > Yes, maybe that's better than kmalloc.  On my laptop I have 105
> > > modules loaded, with 3778464 total length: I'm wasting 206944
> > > bytes on unused tails of pages.  But that's only 0.06% of my
> > > memory.
> >
> > 105 is also a sign that you picked a somewhat suboptimal config...
> > that's of course your choice but it's a choice that has a small
> > price, if you don't want to pay that price, changing the config to
> > not be entirely insane is a good answer as well ;-)
> 
> To be clear: I run distro kernels on my laptop (Ubuntu in this
> case).  I think this is what we should be optimizing for, or we
> should offer the distros something better than modules.

working for a distro myself... yes I like modules for drivers.
But I also know the thinking about modules in distros is changing a bit.
It used to be "everything must be a module", but that thinking is
changing to be a bit more balanced. Things that would be loaded always
are being built in now more and more; Greg is doing that for SuSE, Dave
has been doing that for Fedora, I've been doing it for Moblin and I
think Ubuntu is also going in that direction as well. 

Modules have some overhead in various places (both load and runtime)
that justifies applying ones brain when making choices for distribution
kernels.

--
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
