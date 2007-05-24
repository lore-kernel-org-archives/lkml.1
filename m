Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbXEXW0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbXEXW0M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 18:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbXEXWZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 18:25:57 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:48565 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750885AbXEXWZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 18:25:56 -0400
Date: Thu, 24 May 2007 15:23:56 -0700 (PDT)
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
In-Reply-To: <alpine.LFD.0.98.0705241507050.26602@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.98.0705241517110.26602@woody.linux-foundation.org>
References: <20070521191612.800400000@sous-sol.org> <4652070D.3090509@redhat.com>
 <alpine.LFD.0.98.0705211406000.3890@woody.linux-foundation.org>
 <20070521212522.GL3429@sequoia.sous-sol.org> <1179870110.16656.2.camel@localhost>
 <alpine.LFD.0.98.0705221452290.3890@woody.linux-foundation.org>
 <1180008394.15600.26.camel@localhost> <alpine.LFD.0.98.0705240854250.26602@woody.linux-foundation.org>
 <20070524200435.GA9604@elf.ucw.cz> <alpine.LFD.0.98.0705241323361.26602@woody.linux-foundation.org>
 <20070524220017.GC9604@elf.ucw.cz>
 <alpine.LFD.0.98.0705241507050.26602@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 24 May 2007, Linus Torvalds wrote:
> 
> Then, what you do is:
>  - stop user space
>  - suspend
>  - resume
>  - start user space

Btw, this is where things like "udevd" can be really problematic. That 
whole "uevent over netlink" stuff is really nasty for things like this.

It's quite possible that even for user-level threads, we simply MUST NOT 
freeze them the way we do. Exactly because of deadlocks.

I'm personally really really convinced that the whole freezer thing is a 
total disaster. I don't know how anybody can even imagine anything else. 
It's simply deadlock city.

We should freeze IO, not processes.

		Linus
