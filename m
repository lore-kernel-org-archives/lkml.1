Return-Path: <linux-kernel-owner+w=401wt.eu-S1756979AbZFALcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979AbZFALcL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 07:32:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbZFALb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 07:31:59 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49689 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511AbZFALb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 07:31:58 -0400
Date: Mon, 1 Jun 2009 13:31:51 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Oliver Neukum <oliver@neukum.org>
Cc: kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: ttyACM0: 2.6.30-rc7 dies on device disconnect, strange echo
	(regressions)
Message-ID: <20090601113151.GB2445@elf.ucw.cz>
References: <20090601101421.GA1914@elf.ucw.cz> <20090601102546.GA2288@elf.ucw.cz> <200906011242.06244.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906011242.06244.oliver@neukum.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

First, thanks for quick reply.

> > > I believe this worked before; on 2.6.30-rc7, when ttyACM0 dies
> > > (openmoko in bootloader powers off) the notebook I'm running minicom
> > > on dies, too :-(. For the first time, I did not catch any messages,
> > > I'll retry the test on console.
> >
> > Nothing useful on the console...
> >
> > And it gets worse: with 2.6.30-rc7, I only get echo on character N
> > when I type character N=1. Which is extremely confusing and basically
> > makes it unusable for interactive work. This definitely worked
> > before... but it was quite long ago.

> Do you have any reason to assume these bugs are related? If not,
> please keep them separate.

Well, ok, they are probably two different bugs...

> Can you please be more specific what exactly fails?

...but it is quite easy to test for both of them and they seem to be
introduced in similar timeframe.

Steps to reproduce:

minicom /dev/ttyACM0

Bug #2: try to interactivelly communicate with the other
device. Notice that characters are echoed one character too late. You
type "hello", but only "hell" appears. You press "!", "o" appears. 

Bug #1: while minicom is still connected, pull the USB cable. Machine
locks hard.

Now, both bugs are present in 2.6.28, and 2.6.24-rc8 does not have
either problem.

It would be nice if someone could verify if it also happens with
regular USB modem -- I'm using openmoko to reproduce it.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
