Return-Path: <linux-kernel-owner+w=401wt.eu-S932143AbXCPHkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143AbXCPHkR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 03:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932173AbXCPHkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 03:40:17 -0400
Received: from www.osadl.org ([213.239.205.134]:35087 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932143AbXCPHkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 03:40:15 -0400
Subject: Re: [patch 6/13] signalfd/timerfd/asyncfd v5 - timerfd core ...
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703151556290.4998@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.13805.1173910766.6>
	 <1173995889.13341.217.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0703151556290.4998@alien.or.mcafeemobile.com>
Content-Type: text/plain
Date: Fri, 16 Mar 2007 08:47:03 +0100
Message-Id: <1174031223.13341.251.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-15 at 16:02 -0700, Davide Libenzi wrote:
> > > +		/*
> > > +		 * When we call this, the initialization must be complete, since
> > > +		 * aino_getfd() will install the fd.
> > > +		 */
> > > +		error = aino_getfd(&ufd, &inode, &file, "[timerfd]",
> > > +				   &timerfd_fops, ctx);
> > > +		if (error)
> > > +			goto err_ctxfree;
> > 
> > Again: Please turn this around. No need to start the timer before we
> > know, that everything works. 
> 
> The timerfd_setup() is not locked, so we need to make sure everything is 
> setup, before advertising the fd (and aino_getfd does that).

Right. Did not think about the bad boys peeking at file descriptors :)

	tglx


