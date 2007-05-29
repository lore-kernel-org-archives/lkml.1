Return-Path: <linux-kernel-owner+w=401wt.eu-S1751962AbXE2Vf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbXE2Vf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 17:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750815AbXE2VfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 17:35:15 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55691 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750722AbXE2VfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 17:35:13 -0400
Date: Tue, 29 May 2007 14:33:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
cc: Mark Lord <lkml@rtr.ca>, Pavel Machek <pavel@ucw.cz>,
       Romano Giannetti <romanol@upcomillas.es>,
       Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
In-Reply-To: <1180473765.20718.47.camel@nigel.suspend2.net>
Message-ID: <alpine.LFD.0.98.0705291428410.26602@woody.linux-foundation.org>
References: <1179870110.16656.2.camel@localhost>  <1180008394.15600.26.camel@localhost>
  <alpine.LFD.0.98.0705240854250.26602@woody.linux-foundation.org> 
 <20070524200435.GA9604@elf.ucw.cz>  <alpine.LFD.0.98.0705241323361.26602@woody.linux-foundation.org>
  <20070524220017.GC9604@elf.ucw.cz>  <alpine.LFD.0.98.0705241507050.26602@woody.linux-foundation.org>
  <20070524221743.GD9604@elf.ucw.cz>  <alpine.LFD.0.98.0705241550030.26602@woody.linux-foundation.org>
  <20070524231852.GG9604@elf.ucw.cz>  <alpine.LFD.0.98.0705241736120.26602@woody.linux-foundation.org>
  <1180058123.3997.91.camel@nigel.suspend2.net> 
 <alpine.LFD.0.98.0705241905490.26602@woody.linux-foundation.org> 
 <1180059605.3997.100.camel@nigel.suspend2.net> 
 <alpine.LFD.0.98.0705241931240.26602@woody.linux-foundation.org> 
 <1180062040.3997.112.camel@nigel.suspend2.net> 
 <alpine.LFD.0.98.0705242021560.26602@woody.linux-foundation.org> 
 <1180067587.3997.136.camel@nigel.suspend2.net>  <465C366C.2070900@rtr.ca>
 <1180473765.20718.47.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 May 2007, Nigel Cunningham wrote:
> 
> On Tue, 2007-05-29 at 10:19 -0400, Mark Lord wrote:
> > 
> > How about blocking brk() and mmap(MAP_ANONYMOUS) in addition to
> > the filesystem VFS callers?   Or is that starting to get messy again?
> 
> Yeah. Getting messy again :)

Indeed. And also misses the point - the point being that we don't actually 
need to freeze anything at all most of the time. There's nothing wrong 
with making memory allocations etc.

And yes, suspend is different from hibernate. I can see how hibernate 
people are worried about people writing to things after doing the 
snapshot, but those concerns don't exist with suspend. With suspend, the 
biggest concern is accessing a device after it has been suspended, but on 
the other hand, also the fact that we end up having driver writers used 
to the system being "runnable", so they do things that really do require a 
full-fledged system (and sometimes that means just some delayed action 
using a kernel thread, other times it seems to rely on more complex 
behaviour like firmware loading :^p )

			Linus
