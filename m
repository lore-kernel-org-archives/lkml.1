Return-Path: <linux-kernel-owner+w=401wt.eu-S932733AbXBZMCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733AbXBZMCI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 07:02:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbXBZMCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 07:02:08 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:41120 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752437AbXBZMCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 07:02:06 -0500
Date: Mon, 26 Feb 2007 13:01:54 +0100
From: Pavel Machek <pavel@ucw.cz>
To: David Howells <dhowells@redhat.com>
Cc: Markus Gutschke <markus@google.com>,
       "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>,
       Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>, Robin Holt <holt@sgi.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>
Subject: Re: [PATCH 0/4] coredump: core dump masking support v3
Message-ID: <20070226120154.GD3386@elf.ucw.cz>
References: <45E09989.5070604@google.com> <45DFB1C7.1030205@google.com> <45D5B2E3.3030607@hitachi.com> <17044.1172311335@redhat.com> <2910.1172490554@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2910.1172490554@redhat.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > While I am sure you could construct scenarios where this would happen,
> > realistically the only one I have run into were stack overflows, and they can
> > be handled by carefully setting up an alternate stack for signal handlers --
> > just make sure the entire stack is already dirtied before you run out of
> > memory (or, turn of overcommitting).
> 
> Duff SIGSEGV or SIGBUS signal handlers are just as realistic.  All that takes
> is for someone to make a programming error.  Remember: error paths are the
> least frequently tested.
> 
> And any time you say "by carefully setting up" you can guarantee someone's
> going to do it wrong.

By same argument, we should just give up the coredumping in kernel. It
is rarely tested, so someone will just get it wrong.

Remember: we are having people with huge apps, and therefore huge
coredumps. They want to hack a kernel in ugly way to make their dumps
smaller.

...but there's better solution for them, create (& debug) userland
coredumping library. No need to hack a kernel.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
