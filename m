Return-Path: <linux-kernel-owner+w=401wt.eu-S1754659AbXEXWzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbXEXWzJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 18:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbXEXWy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 18:54:56 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:37040 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750702AbXEXWyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 18:54:55 -0400
Date: Thu, 24 May 2007 15:53:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
cc: Romano Giannetti <romanol@upcomillas.es>,
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
In-Reply-To: <20070524221743.GD9604@elf.ucw.cz>
Message-ID: <alpine.LFD.0.98.0705241550030.26602@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0705211406000.3890@woody.linux-foundation.org>
 <20070521212522.GL3429@sequoia.sous-sol.org> <1179870110.16656.2.camel@localhost>
 <alpine.LFD.0.98.0705221452290.3890@woody.linux-foundation.org>
 <1180008394.15600.26.camel@localhost> <alpine.LFD.0.98.0705240854250.26602@woody.linux-foundation.org>
 <20070524200435.GA9604@elf.ucw.cz> <alpine.LFD.0.98.0705241323361.26602@woody.linux-foundation.org>
 <20070524220017.GC9604@elf.ucw.cz> <alpine.LFD.0.98.0705241507050.26602@woody.linux-foundation.org>
 <20070524221743.GD9604@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 25 May 2007, Pavel Machek wrote:
> > 
> > Why the HELL cannot you realize that kernel threads are different?
> 
> Ugh? We are talking about request_firmware() here, right? That's
> calling userland helper to load the firmware...? Looks like USER
> thread to me.

Right. And if we had had the nice old /sbin/hotplug thing, it would all 
have worked fine - because it would just have done an execve(), and things 
would be happy.

But people screwed that up too, and now udevd is an undebuggable user 
thread. Shit happens. See my other email about why even user threads can 
probably not be frozen, and the whole freezer thing is misdesigned.

And I repeat: PowerPC had working and stable suspend five _years_ ago, 
without any of that freezing crud. We should rip it out.

		Linus
