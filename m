Return-Path: <linux-kernel-owner+w=401wt.eu-S1759676AbXIXUVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759676AbXIXUVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 16:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbXIXUVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 16:21:46 -0400
Received: from nn7.de ([85.214.94.156]:35307 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756562AbXIXUVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 16:21:44 -0400
Subject: Re: 2.6.22.6: kernel BUG at fs/locks.c:171
From: Soeren Sonnenburg <kernel@nn7.de>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: linux-fsdevel@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200709140722.58046.nickpiggin@yahoo.com.au>
References: <1189675222.5352.10.camel@localhost>
	 <200709130951.48194.nickpiggin@yahoo.com.au>
	 <1189749754.25045.10.camel@localhost>
	 <200709140722.58046.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 24 Sep 2007 22:21:38 +0200
Message-Id: <1190665298.4408.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-09-14 at 07:22 +1000, Nick Piggin wrote:
> On Friday 14 September 2007 16:02, Soeren Sonnenburg wrote:
> > On Thu, 2007-09-13 at 09:51 +1000, Nick Piggin wrote:
> > > On Thursday 13 September 2007 19:20, Soeren Sonnenburg wrote:
> > > > Dear all,
> > > >
> > > > I've just seen this in dmesg on a AMD K7 / kernel 2.6.22.6 machine
> > > > (config attached).
> > > >
> > > > Any ideas / which further information needed ?
> > >
> > > Thanks for the report. Is it reproduceable? It seems like the
> > > locks_free_lock call that's oopsing is coming from __posix_lock_file.
> > > The actual function looks fine, but the lock being freed could have
> > > been corrupted if there was slab corruption, or a hardware corruption.
> > >
> > > You could: try running memtest86+ overnight. And try the following
> > > patch and turn on slab debugging then try to reproduce the problem.
> >
> > OK so far I've run memtest86+ 1.40 from freedos for 8 hrs (v1.70 hung on
> > startup) - nothing.
> 
> Thanks.
> 
> > Could this corruption be caused by a pci card/driver? I am asking as I
> > am using a new dvb-t card (asus p7131) and the oops happened after 5 or
> > 6 days of uptime just about a day after watching some movie (very bad
> > reception/lots of errors).
> 
> It could be caused by that, definitely. slab debugging plus my earlier
> patch may help to narrow it down. (or stress testing with / without the
> dvb card in action).

OK, it is the dvb card. I have 1 week of uptime now without any errors.
Only change is the dvb driver (saa7146) not loaded.

:(
Soeren
