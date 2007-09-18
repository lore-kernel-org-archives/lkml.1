Return-Path: <linux-kernel-owner+w=401wt.eu-S1755292AbXIRJnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbXIRJnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 05:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751264AbXIRJm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 05:42:58 -0400
Received: from www.osadl.org ([213.239.205.134]:59464 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751102AbXIRJm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 05:42:57 -0400
Subject: Re: RFC: A revised timerfd API
From: Thomas Gleixner <tglx@linutronix.de>
To: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: Lee.Schermerhorn@hp.com, torvalds@linux-foundation.org,
       vda.linux@googlemail.com, rdunlap@xenotime.net, corbet@lwn.net,
       hch@lst.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       geoff@gclare.org.uk, drepper@redhat.com, davidel@xmailserver.org,
       David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
In-Reply-To: <20070918093007.223350@gmx.net>
References: <46EF7DDA.2070401@gmx.net>  <46EF7E82.8040503@gmx.net>
	 <1190106607.2995.97.camel@chaos>  <20070918093007.223350@gmx.net>
Content-Type: text/plain; charset=utf-8
Date: Tue, 18 Sep 2007 11:42:22 +0200
Message-Id: <1190108542.2995.112.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92 (2.11.92-1.fc8) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-18 at 11:30 +0200, Michael Kerrisk wrote:
> > This way we have it nicely integrated into the posix timer code and keep
> > the existing semantics of posix timers intact.
> > 
> > We need to think about the open file descriptor in the timer_delete()
> > case as well, but this should be not too hard to sort out.
> 
> This seems like a workable idea also.  But note David Härdeman's
> critique of options c & d: the existence of a coupled timerfd 
> and a timerid means that the application must maintain a mapping
> between the two, so that after an epoll call (for example) that 
> says the timerfd is ready, the timer can be manipulated using
> the corresponding timerfd.  This isn't IMO a fatal flaw, but
> it does make the API a little more clumsy.

Hmm, we might do something like:

	timer_gettime(fd | POSIX_TIMER_FD, .....);

So the kernel looks up the fd in order to figure out the timer_id, which
needs to be referenced in filep->private_data anyway.

	tglx


