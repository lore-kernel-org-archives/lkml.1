Return-Path: <linux-kernel-owner+w=401wt.eu-S932694AbXB0G2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694AbXB0G2r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 01:28:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932847AbXB0G2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 01:28:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36384 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932694AbXB0G2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 01:28:46 -0500
Date: Tue, 27 Feb 2007 07:20:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 05/13] syslets: core, documentation
Message-ID: <20070227062054.GA1259@elte.hu>
References: <20070221211355.GA7302@elte.hu> <20070221211521.GE7579@elte.hu> <20070226133210.65566d7a.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070226133210.65566d7a.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> > + [ Note: since the argument array is at the end of the atom, and the
> > +   kernel will not touch any argument beyond the final NULL one, atoms
> 
> I would s/final/first/ since one could put many (unneeded) NULL 
> pointers in the argument array.

ok, fixed.

> > +Completion of asynchronous syslets is done via the 'completion ring',
> > +which is a ringbuffer of syslet atom pointers user user-space memory,
> 
>    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ^^^^ ^^^^ ??

fixed - it's "in user-space memory".

> > +provided by user-space as an argument to the sys_async_exec() syscall.
> > +The kernel fills in the ringbuffer starting at index 0, and user-space
> > +must clear out these pointers. Once the kernel reaches the end of
> > +the ring it wraps back to index 0. The kernel will not overwrite
> > +non-NULL pointers (but will return an error), user-space has to
> > +make sure it completes all events it asked for.
> 
> Last sentence is actually 2 sentences, so (e.g.) change the comma
> to a semi-colon, xor begin the sentence with "Since".

i've changed it to ', and thus user-space has to make sure'.

> How does the kernel return an error if the ring buffer is full? Just a 
> syscall negative error return code?

correct - we return a -EFAULT in that case. Should probably do something 
more distinguished though?

> > +	/*
> > +	 * Simple syslet consisting of a single atom:
> > +	 */
> > +	init_atom(&atom, __NR_sys_write, &fd_out, &buf, &size,
> > +		  NULL, NULL, NULL, NULL, SYSLET_ASYNC, NULL);
> 
> init_atom() (was) above.  sys_async_exec(), sys_async_wait() are new 
> syscalls.  What are async_head_init() and async_head_exit()?

They used to initialize kernel-side stuff too, but now they only 
initialize the user-space-head structure: the ring and a 'head stack 
pointer'.

	Ingo
