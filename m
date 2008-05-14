Return-Path: <linux-kernel-owner+w=401wt.eu-S1758619AbYENWH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619AbYENWH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 18:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754093AbYENWHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 18:07:48 -0400
Received: from vena.lwn.net ([206.168.112.25]:56677 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349AbYENWHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 18:07:47 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [announce] "kill the Big Kernel Lock (BKL)" tree 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Wed, 14 May 2008 14:56:37 PDT."
             <alpine.LFD.1.10.0805141452330.3019@woody.linux-foundation.org> 
Date: Wed, 14 May 2008 16:07:47 -0600
Message-ID: <7207.1210802867@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> I don't think there are *that* many. I found only 83 instances of 
> "register_chrdev()" in the kernel, so the open methods should be pretty 
> limited.

There's the drivers calling cdev_add() directly as well - another
40ish.  Still not a huge list, I guess.
 
> So it literally should be:
>  - remove one lock_kernel/unlock_kernel pair in fs/char_dev.c
>  - add max 83 pairs in the places that register those things
>  - external modules will need to add it themselves some day.

This is all certainly doable, but it leaves me with one concern: there
will be no signal to external module maintainers that the change needs
to be made.  So, beyond doubt, quite a few of them will just continue to
be shipped unfixed - and they will still run.  If any of them actually
*need* the BKL, something awful may happen to somebody someday.

jon
