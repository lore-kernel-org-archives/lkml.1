Return-Path: <linux-kernel-owner+w=401wt.eu-S1755295AbYFYWsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295AbYFYWsE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 18:48:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbYFYWr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 18:47:56 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60369 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750836AbYFYWrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 18:47:55 -0400
Date: Wed, 25 Jun 2008 23:30:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jonathan Corbet <corbet@lwn.net>
Cc: David Brownell <david-b@pacbell.net>, lkml <linux-kernel@vger.kernel.org>,
       rtc-linux@googlegroups.com
Subject: Re: [PATCH] rtc: remove BKL for ioctl()
Message-ID: <20080625233017.5b207e94@lxorguk.ukuu.org.uk>
In-Reply-To: <20080625163928.4da1f4a0@bike.lwn.net>
References: <200806221955.42597.david-b@pacbell.net>
	<20080625163928.4da1f4a0@bike.lwn.net>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2008 16:39:28 -0600
Jonathan Corbet <corbet@lwn.net> wrote:

> On Sun, 22 Jun 2008 19:55:42 -0700
> David Brownell <david-b@pacbell.net> wrote:
> 
> > Remove implicit use of BKL in ioctl() from the RTC framework.
> 
> Looks good, I'll happily put it into the bkl-removal tree.  One
> question, though:
> 
> > +	err = mutex_lock_interruptible(&rtc->ops_lock);
> > +	if (err)
> > +		return -EBUSY;
> > +
> 
> Shouldn't that be -EINTR?

For an ioctl case which should never be blocking for long periods it
shouldn't be _interruptible in the first place, that will just introduce
bizarre and weird bugs in application code.

If there are slow ops they should drop and retake the lock.

Alan
