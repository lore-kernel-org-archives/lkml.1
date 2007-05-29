Return-Path: <linux-kernel-owner+w=401wt.eu-S1759102AbXE2OTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759102AbXE2OTg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 10:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbXE2OT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 10:19:27 -0400
Received: from rtr.ca ([64.26.128.89]:3818 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbXE2OT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 10:19:27 -0400
Message-ID: <465C366C.2070900@rtr.ca>
Date: Tue, 29 May 2007 10:19:24 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: nigel@nigel.suspend2.net
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>, Romano Giannetti <romanol@upcomillas.es>,
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
References: <1179870110.16656.2.camel@localhost>	 <1180008394.15600.26.camel@localhost>	 <alpine.LFD.0.98.0705240854250.26602@woody.linux-foundation.org>	 <20070524200435.GA9604@elf.ucw.cz>	 <alpine.LFD.0.98.0705241323361.26602@woody.linux-foundation.org>	 <20070524220017.GC9604@elf.ucw.cz>	 <alpine.LFD.0.98.0705241507050.26602@woody.linux-foundation.org>	 <20070524221743.GD9604@elf.ucw.cz>	 <alpine.LFD.0.98.0705241550030.26602@woody.linux-foundation.org>	 <20070524231852.GG9604@elf.ucw.cz>	 <alpine.LFD.0.98.0705241736120.26602@woody.linux-foundation.org>	 <1180058123.3997.91.camel@nigel.suspend2.net>	 <alpine.LFD.0.98.0705241905490.26602@woody.linux-foundation.org>	 <1180059605.3997.100.camel@nigel.suspend2.net>	 <alpine.LFD.0.98.0705241931240.26602@woody.linux-foundation.org>	 <1180062040.3997.112.camel@nigel.suspend2.net>	 <alpine.LFD.0.98.0705242021560.26602@woody.linux-foundation.org> <1180067587.3997.136.camel@nigel.suspend2.net>
In-Reply-To: <1180067587.3997.136.camel@nigel.suspend2.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nigel Cunningham wrote:
>
> I'm sorry to say it, but dropping process freezing still seems to me
> like the better way though. I prefer it because of the reliability
> aspect. With the current code, having frozen processes, I can look at
> the state of memory, calculate how much I'll need for this or that and
> know that I'll have sufficient memory for the atomic copy and for doing
> the I/O  (making assumptions about how much memory drivers will
> allocate) before I start to do either. If we stop freezing processes,
> that predictability will go away. There'll always be a possibility that
> some process will get memory hungry and stop me from being able to get
> the image on disk, and I'll have to either abort or give up and try
> again and again until I can complete writing the image, the battery runs
> out or whatever... 

How about blocking brk() and mmap(MAP_ANONYMOUS) in addition to
the filesystem VFS callers?   Or is that starting to get messy again?

Cheers

