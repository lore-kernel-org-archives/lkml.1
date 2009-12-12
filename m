Return-Path: <linux-kernel-owner+w=401wt.eu-S935082AbZLMBzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935082AbZLMBzV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 20:55:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935044AbZLMBzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 20:55:17 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53508 "HELO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S935011AbZLMBzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 20:55:16 -0500
Date: Sat, 12 Dec 2009 21:42:35 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <gregkh@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] TTY patches for 2.6.33-git
Message-ID: <20091212214235.31429790@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.0912120920190.3526@localhost.localdomain>
References: <20091211232805.GA10652@kroah.com>
	<20091212084611.GA28266@elte.hu>
	<20091212013927.58d386d1.akpm@linux-foundation.org>
	<20091212101032.GB25286@elte.hu>
	<20091212023603.93768833.akpm@linux-foundation.org>
	<alpine.LFD.2.00.0912120915390.3526@localhost.localdomain>
	<alpine.LFD.2.00.0912120920190.3526@localhost.localdomain>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think we could possibly add a "__might_sleep()" to _lock_kernel(). It 
> doesn't really sleep, but it's invalid to take the kernel lock in an 
> atomic region, so __might_sleep() might be the right thing anyway.

It's only invalid if you don't already hold the lock. The old tty code
worked because every path into tty_fasync already held the lock ! That
specific case - taking it the first time should definitely
__might_sleep().

Mind you it's probably still rather dumb and would be a good debugging
aid for -next to be able to warn on all offences if only to catch this
stuff for the future BKL removal work.

Alan
