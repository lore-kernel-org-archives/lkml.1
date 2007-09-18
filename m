Return-Path: <linux-kernel-owner+w=401wt.eu-S1756271AbXIRLa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271AbXIRLa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 07:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754915AbXIRLaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 07:30:17 -0400
Received: from www.osadl.org ([213.239.205.134]:34113 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755426AbXIRLaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 07:30:15 -0400
Subject: Re: RFC: A revised timerfd API
From: Thomas Gleixner <tglx@linutronix.de>
To: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: david@hardeman.nu, davidel@xmailserver.org, drepper@redhat.com,
       geoff@gclare.org.uk, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, hch@lst.de, corbet@lwn.net,
       rdunlap@xenotime.net, vda.linux@googlemail.com,
       torvalds@linux-foundation.org, Lee.Schermerhorn@hp.com
In-Reply-To: <20070918110841.235150@gmx.net>
References: <46EF7DDA.2070401@gmx.net>  <46EF7E82.8040503@gmx.net>
	 <1190106607.2995.97.camel@chaos>  <20070918093007.223350@gmx.net>
	 <1190108542.2995.112.camel@chaos>  <20070918110841.235150@gmx.net>
Content-Type: text/plain
Date: Tue, 18 Sep 2007 13:30:11 +0200
Message-Id: <1190115011.2995.126.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92 (2.11.92-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-18 at 13:08 +0200, Michael Kerrisk wrote:
> > > it does make the API a little more clumsy.
> > 
> > Hmm, we might do something like:
> > 
> > 	timer_gettime(fd | POSIX_TIMER_FD, .....);
> > 
> > So the kernel looks up the fd in order to figure out the timer_id, which
> > needs to be referenced in filep->private_data anyway.
> 
> And you'd need similar for timer_settime() and, perhaps,
> timer_getoverrun().  But it seems slightly ugly, in the same way that
> my idea in option (d) of returning a file descriptor from
> timer_create() seems a slightly ugly.  (And can we guarantee that
> the [timerid] space is distinct from the [fd|POSIX_TIMER_FD] space?)

If we use the most significant bit for POSIX_TIMER_FD, we should be
fine.

	tglx


