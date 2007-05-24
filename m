Return-Path: <linux-kernel-owner+w=401wt.eu-S1753146AbXEXU3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146AbXEXU3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 16:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750929AbXEXU3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 16:29:32 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:54033 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750841AbXEXU3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 16:29:31 -0400
Date: Thu, 24 May 2007 13:27:37 -0700 (PDT)
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
In-Reply-To: <20070524200435.GA9604@elf.ucw.cz>
Message-ID: <alpine.LFD.0.98.0705241323361.26602@woody.linux-foundation.org>
References: <20070521191612.800400000@sous-sol.org> <4652070D.3090509@redhat.com>
 <alpine.LFD.0.98.0705211406000.3890@woody.linux-foundation.org>
 <20070521212522.GL3429@sequoia.sous-sol.org> <1179870110.16656.2.camel@localhost>
 <alpine.LFD.0.98.0705221452290.3890@woody.linux-foundation.org>
 <1180008394.15600.26.camel@localhost> <alpine.LFD.0.98.0705240854250.26602@woody.linux-foundation.org>
 <20070524200435.GA9604@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 24 May 2007, Pavel Machek wrote:
> 
> If someone does request_firmware from resume function... that's
> bad. Resume function should be fixed. Pcmcia? ti12xx driver?

Probably pcmcia "ds" driver and CONFIG_PCMCIA_LOAD_CIS.

> Well. we'd like to present hardware in working state as soon as we
> resume (if eth0 was there before resume, it should be there after
> resume. not 3 seconds after resume); so if someone needs to load the
> firmware, they should just store it in the kernel memory, and load it
> during boot or during (very early) suspend.

Equally arguably, we should just have a "resume_late()" call that can be 
used to do this after everything is up and running.

And quite frankly, I don't actually see any reason why firmware loading 
shouldn't work in the resume path. I really do think that this is ANOTHER 
bug that has no other reason than the fact that that f*cking freezer 
killed the system for no really good reason.

		Linus
