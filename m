Return-Path: <linux-kernel-owner+w=401wt.eu-S1757152AbXIVRF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152AbXIVRF3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 13:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753684AbXIVRFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 13:05:21 -0400
Received: from www.osadl.org ([213.239.205.134]:52615 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752359AbXIVRFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 13:05:20 -0400
Subject: Re: RFC: A revised timerfd API
From: Thomas Gleixner <tglx@linutronix.de>
To: Michael Kerrisk <mtk.linux.lists@gmail.com>
Cc: Bernd Eckenfels <ecki@lina.inka.de>, linux-kernel@vger.kernel.org,
       Ulrich Drepper <drepper@redhat.com>, geoff@gclare.org.uk,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>, Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <rdunlap@xenotime.net>, vda.linux@googlemail.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
       mtk-manpages@gmx.net
In-Reply-To: <517f3f820709220907l4c4e693di3df6942bdca5bcfa@mail.gmail.com>
References: <46F514C9.5010208@gmx.net>
	 <E1IZ62P-0000EX-00@calista.eckenfels.net>
	 <517f3f820709220907l4c4e693di3df6942bdca5bcfa@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 22 Sep 2007 19:05:17 +0200
Message-Id: <1190480717.4035.45.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-09-22 at 18:07 +0200, Michael Kerrisk wrote:
> Hello Bernd,
> 
> Please don't trim the CC list when replying!  I nearly did not see
> your reply, and others will have missed it also.

Yup.

> On 9/22/07, Bernd Eckenfels <ecki@lina.inka.de> wrote:
> > In article <46F514C9.5010208@gmx.net> you wrote:
> > >  1. This design stretches the POSIX timers API in strange
> > >     ways.
> >
> > Maybe it is possible to reimplement the POSIX API in usermode using the
> > kernel's FD implementation?

Yikes.

> It's a clever idea...  Without thinking on it too long, I'm not sure
> whether or not there might be some details which would make this
> difficult.

You'd need be quite masochistic to start such a project. The POSIX timer
API consists mostly of corner cases and I doubt that you get them even
halfway under control in a pure user space implementation.

It would be a rather huge performance penalty as well. You need at least
two user space context switches to get the most simple cases resolved.

> > (and drop the posix support from kernel)
> 
> However we couldn't drop POSIX support from the kernel, because that
> would break the ABI.

True. So there is no point in reinventing the wheel.

	tglx


