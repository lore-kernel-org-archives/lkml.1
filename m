Return-Path: <linux-kernel-owner+w=401wt.eu-S1756714AbYIIRoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714AbYIIRoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 13:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbYIIRoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 13:44:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753904AbYIIRoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 13:44:05 -0400
Date: Tue, 9 Sep 2008 10:43:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Joe Peterson <joe@skyrush.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TTY: Fix loss of echoed characters (2nd follow-on PATCH
 attached)
Message-Id: <20080909104325.4653190b.akpm@linux-foundation.org>
In-Reply-To: <20080909115536.1664d57a@lxorguk.ukuu.org.uk>
References: <200807252257.m6PMvieO003213@imap1.linux-foundation.org>
	<48AC3A16.4080209@skyrush.com>
	<48B3F9F7.2050503@skyrush.com>
	<48C54EC2.4060901@skyrush.com>
	<20080908173250.2452c5b8.akpm@linux-foundation.org>
	<20080909115536.1664d57a@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Sep 2008 11:55:36 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Mon, 8 Sep 2008 17:32:50 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Mon, 08 Sep 2008 10:11:46 -0600
> > Joe Peterson <joe@skyrush.com> wrote:
> > 
> > > +	spin_lock_irqsave(&tty->echo_lock, flags);
> > >  	lock_kernel();
> > 
> > Taking a spinlock outside lock_kernel() isn't good, and is quite unusual.
> > 
> > - It might be ab/ba deadlockable (I didn't check) (I trust you always
> >   test with lockdep enabled?)
> 
> lock_kernel can sleep.

That used to be the case, but the mutex_lock() version of the bkl got
removed.  It may of course come back.

> Its not allowed...
> 

yup.
