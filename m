Return-Path: <linux-kernel-owner+w=401wt.eu-S933058AbYETPN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933058AbYETPN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763950AbYETPNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:13:45 -0400
Received: from vena.lwn.net ([206.168.112.25]:36070 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756666AbYETPNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:13:44 -0400
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org,
       Wim Van Sebroeck <wim@iguana.be>
Subject: Re: [PATCH, RFC] char dev BKL pushdown 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Tue, 20 May 2008 01:07:49 +0200."
             <200805200107.51659.arnd@arndb.de> 
Date: Tue, 20 May 2008 09:13:43 -0600
Message-ID: <25447.1211296423@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> wrote:

> I've given it a try for all the misc drivers that have an open() function.
> The vast majority of them are actually watchdog drivers, all of which
> register as a misc device by themselves. 

OK, it looks like the "misc" misc drivers patch can go into the
bkl-removal tree, while the watchdog patches should not.  What that
means, I guess, is that the final misc_open() patch cannot go in at this
point; Alan's watchdog stuff needs to find its way in first.  Make
sense? 

> You seem to already have a script to turn per-file changes into a
> patch each, so I'm sending you two patches: one for all the watchdog
> drivers (maybe Wim can take care of that as well) and one for all the
> other misc drivers (this one needs to be split).

Alas, I have no such script.  I just committed each change as I made it
- each one required individual attention anyway.  The misc changes look
pretty straightforward, so I could probably hack up such a thing pretty
quickly if you don't have a tree with broken out patches.

Thanks,

jon
