Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbYIIK4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbYIIK4R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 06:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbYIIK4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 06:56:00 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37824 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751842AbYIIKz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 06:55:59 -0400
Date: Tue, 9 Sep 2008 11:55:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Peterson <joe@skyrush.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TTY: Fix loss of echoed characters (2nd follow-on PATCH
 attached)
Message-ID: <20080909115536.1664d57a@lxorguk.ukuu.org.uk>
In-Reply-To: <20080908173250.2452c5b8.akpm@linux-foundation.org>
References: <200807252257.m6PMvieO003213@imap1.linux-foundation.org>
	<48AC3A16.4080209@skyrush.com>
	<48B3F9F7.2050503@skyrush.com>
	<48C54EC2.4060901@skyrush.com>
	<20080908173250.2452c5b8.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Sep 2008 17:32:50 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 08 Sep 2008 10:11:46 -0600
> Joe Peterson <joe@skyrush.com> wrote:
> 
> > +	spin_lock_irqsave(&tty->echo_lock, flags);
> >  	lock_kernel();
> 
> Taking a spinlock outside lock_kernel() isn't good, and is quite unusual.
> 
> - It might be ab/ba deadlockable (I didn't check) (I trust you always
>   test with lockdep enabled?)

lock_kernel can sleep. Its not allowed...

Alan
