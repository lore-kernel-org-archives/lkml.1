Return-Path: <linux-kernel-owner+w=401wt.eu-S1757990AbYERU1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990AbYERU1A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 16:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754881AbYERU0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 16:26:52 -0400
Received: from vena.lwn.net ([206.168.112.25]:43014 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754273AbYERU0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 16:26:51 -0400
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] char dev BKL pushdown 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Sat, 17 May 2008 23:15:00 +0200."
             <200805172315.02988.arnd@arndb.de> 
Date: Sun, 18 May 2008 14:26:51 -0600
Message-ID: <13762.1211142411@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> wrote:

> Note that the majority of drivers use (grep suggests up to 165
> of them) uses misc_register instead of register_chrdev/cdev_add.
> Your patches are still correct, because you pushed the BKL into the
> misc_open function, but there is an obvious next step in pushing
> it further into the misc drivers.

There's a few intermediate dispatcher levels like this, actually.
Lots of video drivers get called behind video_open(), usb drivers from
usb_open(), etc.  Not much to be done but to push things down one level
at a time.

> In your current git tree, this change is no longer the final one, so
> bisecting the series may cause other bugs. You should probably reorder
> the patches at some point to avoid this.

Bisection is going to be problem regardless - if a problem turns up,
it's going to be the chrdev_open() change which gets fingered.  I bet,
though, that it will be a rare BKL-related problem which is reproducible
enough to be easily bisectable.

But, yes, I do need to reorganize the patch series once I'm done adding
on changes.

jon
