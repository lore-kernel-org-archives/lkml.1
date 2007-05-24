Return-Path: <linux-kernel-owner+w=401wt.eu-S1753584AbXEXU6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbXEXU6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 16:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbXEXU6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 16:58:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41739 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755AbXEXU6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 16:58:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
Date: Thu, 24 May 2007 23:03:17 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Romano Giannetti <romanol@upcomillas.es>,
       Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
References: <20070521191612.800400000@sous-sol.org> <20070524200435.GA9604@elf.ucw.cz> <alpine.LFD.0.98.0705241323361.26602@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705241323361.26602@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705242303.19241.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 24 May 2007 22:27, Linus Torvalds wrote:
> 
> On Thu, 24 May 2007, Pavel Machek wrote:
> > 
> > If someone does request_firmware from resume function... that's
> > bad. Resume function should be fixed. Pcmcia? ti12xx driver?
> 
> Probably pcmcia "ds" driver and CONFIG_PCMCIA_LOAD_CIS.
> 
> > Well. we'd like to present hardware in working state as soon as we
> > resume (if eth0 was there before resume, it should be there after
> > resume. not 3 seconds after resume); so if someone needs to load the
> > firmware, they should just store it in the kernel memory, and load it
> > during boot or during (very early) suspend.
> 
> Equally arguably, we should just have a "resume_late()" call that can be 
> used to do this after everything is up and running.
> 
> And quite frankly, I don't actually see any reason why firmware loading 
> shouldn't work in the resume path. I really do think that this is ANOTHER 
> bug that has no other reason than the fact that that f*cking freezer 
> killed the system for no really good reason.

Well, if I understand request_firmware() correctly, it does something in sysfs
and waits for the user land to react, but at this point the user land can't do
anything.

Greetings,
Rafael
