Return-Path: <linux-kernel-owner+w=401wt.eu-S1756331AbXIRJ1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331AbXIRJ1i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 05:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754253AbXIRJ1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 05:27:31 -0400
Received: from www.osadl.org ([213.239.205.134]:51242 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754548AbXIRJ1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 05:27:30 -0400
Subject: Re: RFC: A revised timerfd API
From: Thomas Gleixner <tglx@linutronix.de>
To: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: "\"David" =?ISO-8859-1?Q?H=E4rdeman=22?= <david@hardeman.nu>,
       lee.schermerhorn@hp.com, torvalds@linux-foundation.org,
       vda.linux@googlemail.com, rdunlap@xenotime.net, corbet@lwn.net,
       hch@lst.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       geoff@gclare.org.uk, drepper@redhat.com, davidel@xmailserver.org
In-Reply-To: <20070918090110.235160@gmx.net>
References: <46EF7DDA.2070401@gmx.net> <46EF7E82.8040503@gmx.net>
	 <38485.145.64.134.222.1190102719.squirrel@www.hardeman.nu>
	 <20070918090110.235160@gmx.net>
Content-Type: text/plain
Date: Tue, 18 Sep 2007 11:27:15 +0200
Message-Id: <1190107635.2995.109.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92 (2.11.92-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-18 at 11:01 +0200, Michael Kerrisk wrote:
> > With solution c) you have to keep two
> > references to the same timer around and use one of them depending on what
> > you want to do with the timer.
> 
> Yes.  (And the same for option (d).)
> 
> > Also, if the timerfd is close():d, does that remove the underlying timer
> > (invalidate the timerid) as well?
> 
> My gut feeling would be to say that closing the timerfd would not
> remove the underlying timer (so the timerid would remain valid).
> One could even do things like recreating a file descriptor
> for the timer using another timerfd() call.  
> 
> But now that raises the question: what are the semantics if
> timerfd() is called  more than once on the same timerid? 
> Perhaps a read() from any one of them (destructively)
> reads the expiration count, as though one had read from a 
> dup()ed the file descriptor.  All in all, solution (c) 
> starts to look overly complex, and maybe suffers from 
> various dirty corners in the API.  (Solution (d) feels 
> slightly better, because the creation of the file descriptor
> and the timerid are integrated into a single call, and the
> fact that it integrates with an existing API, but
> it still has the limitation you describe above.)

I don't think it is a big problem to have several open file descriptors
on a single posix timer without having destructive reads, we just need
to store the event count per file descriptor in file->private_data. We
solved this in the UIO code already and it works perfectly fine.

	tglx


