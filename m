Return-Path: <linux-kernel-owner+w=401wt.eu-S1762064AbYESNYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762064AbYESNYc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757058AbYESNSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:18:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55687 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759781AbYESNSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:18:32 -0400
Date: Mon, 19 May 2008 15:17:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH, RFC] Char dev BKL pushdown v2
Message-ID: <20080519131722.GB19245@elte.hu>
References: <19845.1211148908@vena.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19845.1211148908@vena.lwn.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jonathan Corbet <corbet@lwn.net> wrote:

> OK, since the previous announcement, I've revisited all of the open() 
> functions which didn't get lock_kernel() calls the first time around. 
> Alan pointed out that even a completely empty open() might, in fact, 
> need to acquire the BKL, so now they all do.  Hopefully, this 
> completes this work (at this level - there's plenty of down-pushing to 
> do within subsystems).

cool stuff! :-)

> There's a new tree with this stuff:
> 
> 	git://git.lwn.net/linux-2.6.git bkl-removal
> 
> Stephen, might it be about time to pull this into linux-next and see 
> what explodes?
> 
> If others have BKL-removal patches which look like 2.6.27 material, 
> I'll happily collect them in this tree.

i'm wondering how this should best interact with the kill-the-BKL bits 
that attack it all from the infrastructure side. Your bits are the safer 
ones, so i guess i'll try to track your changes from my branch to 
increase testing of it all?

	Ingo
