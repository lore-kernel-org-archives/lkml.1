Return-Path: <linux-kernel-owner+w=401wt.eu-S1751859AbZJKT0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859AbZJKT0p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 15:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbZJKT0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 15:26:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:42178 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbZJKT0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 15:26:44 -0400
Date: Sun, 11 Oct 2009 12:26:32 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jonathan Corbet <corbet@lwn.net>, John Kacur <jkacur@redhat.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vincent^M^J Sanders <vince@simtec.co.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] sound_core.c: Remove BKL from soundcore_open
Message-ID: <20091011122632.53a61a09@infradead.org>
In-Reply-To: <20091011201759.435cd93c@lxorguk.ukuu.org.uk>
References: <alpine.LFD.2.00.0910110123510.4921@localhost.localdomain>
	<20091011004219.74c30f67@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.00.0910110223510.4921@localhost.localdomain>
	<20091011092015.37a69847@bike.lwn.net>
	<20091011111543.1cbb9a0e@tpl.lwn.net>
	<20091011103755.649f5ae1@infradead.org>
	<20091011201759.435cd93c@lxorguk.ukuu.org.uk>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Oct 2009 20:17:59 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > it's getting time though to bite the bullet and make it a real
> > normal mutex. Lockdep will then flag a bunch of sh*t we'll need to
> > fix, but without doing that we're never going to really make
> > progress. 
> 
> It won't. Instead you get situations like one ioctl blocking another
> to an unrelated device that just causes weird failures and performance
> problems, or in some cases deadlocks.

yes the bkl using code will be slower because it'll now hit contention.

The deadlocks we need to catch imo; those are the behaviors that are
the worst offenders in terms of BKL weird behavior.

> 
> Open routines block so it takes about 5 seconds of thought to realise
> that using a mutex here is brain dead and doesn't work.

it also takes 5 seconds to realize "uh oh. they block. BKL is rather
limited in what it provides".


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
