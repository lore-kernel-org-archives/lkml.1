Return-Path: <linux-kernel-owner+w=401wt.eu-S1763470AbXGQRHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763470AbXGQRHO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 13:07:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755291AbXGQRHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 13:07:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53187 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755600AbXGQRHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 13:07:00 -0400
Date: Tue, 17 Jul 2007 19:06:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Markus <lists4me@web.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch] CFS scheduler, -v19
Message-ID: <20070717170628.GA6002@elte.hu>
References: <20070706173319.GA2356@elte.hu> <200707161959.17750.lists4me@web.de> <20070717073709.GA12465@elte.hu> <200707171506.37886.lists4me@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707171506.37886.lists4me@web.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Markus <lists4me@web.de> wrote:

> > > Nothing is printed for a disapeared app for me.
> > > 
> > > Is there anything more I can try?
> > 
> > sure - could you start one of those apps via:
> > 
> > 	strace -ttt -TTT -o trace.log -f <app>
> > 
> > and wait for it to "disappear"? Then compress the trace.log via 
> > bzip2 -9 (it's probably going to be a really large file) and send me 
> > it?
> private mail, aswell (187K)

i think it fails here due to some IO error:

 9173  1184675906.674610 write(2, "konqueror: Fatal IO error: clien"..., 41) = 41 <0.000007>

could this be due to:

9173  1184675906.194424 ioctl(1, SNDCTL_TMR_TIMEBASE or TCGETS, 0x7fff341af5c0)
= -1 ENOTTY (Inappropriate ioctl for device) <0.000006>
9173  1184675906.194463 ioctl(2, SNDCTL_TMR_TIMEBASE or TCGETS, 0x7fff341af5c0)
= -1 ENOTTY (Inappropriate ioctl for device) <0.000004>

? Are those -ENOTTY results normal?

or perhaps the problem started alot earlier, at:

9173  1184675906.155015 write(2, "In file kernel/qpixmap_x11.cpp, "..., 56) = 56 <0.000006>
9173  1184675906.155052 write(2, "QImage::convertDepth: Image is a"..., 44) = 44 <0.000004>
9173  1184675906.155169 gettimeofday({1184675906, 155179}, NULL) = 0 <0.000006>
9173  1184675906.155249 write(11, "close(6f1c2f7):about:konqueror\n", 31) = 31 <0.000032>

i think konqueror tried to say something here about an image problem?

could you perhaps upload the strace to some webpage so that others can 
take a look too?

it might also be good to add "-s 1000" to the strace command, so that we 
can see the full messages that konqueror tried to log to some other 
task, i.e.:

  strace -s 1000 -ttt -TTT -o trace.log -f <app>

and perhaps try to do a 'comparison' trace.normal.log as well, with 
konqueror having no problems. Also a KDE expert's advice would be useful 
here too i guess ...

	Ingo
