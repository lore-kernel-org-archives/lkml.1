Return-Path: <linux-kernel-owner+w=401wt.eu-S1757298AbZJLQ0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbZJLQ0x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 12:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756679AbZJLQ0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 12:26:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43951 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756670AbZJLQ0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 12:26:51 -0400
Date: Mon, 12 Oct 2009 18:26:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [crash] NULL pointer dereference at IP: [<ffffffff812e9ccb>]
	uart_close+0x2a/0x1e4
Message-ID: <20091012162600.GD1272@elte.hu>
References: <alpine.LFD.2.01.0910111446410.3438@localhost.localdomain> <20091012080511.GA22607@elte.hu> <alpine.LFD.2.01.0910120850590.3438@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0910120850590.3438@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, 12 Oct 2009, Ingo Molnar wrote:
> > 
> > Note, i have your fix below applied in tip:out-of-tree - it might be 
> > the source of this bug? (If yes then this isnt an .32-rc4 problem.)
> 
> If yes (but you later reported no), it would still be a 32-rc4 
> problem, because that patch got committed as 0b5759c654 ("tty: Avoid 
> dropping ldisc_mutex over hangup tty re-initialization").
> 
> So you shouldn't need it in the out-of-tree branch any more, and you 
> probably just never noticed because it all merged cleanly.

ah, indeed. I'll rebase that branch to clean out any 
went-upstream-already same-content patches. (Ideally that should empty 
it to a large degree.)

> Commit 46d57a449 (which you then bisected to) looks really irritating, 
> since it just renamed variables in annoying ways (ie the old "port" is 
> now "uport", and there's a new "port" that means something else). That 
> thing should have been split up to do the renaming separately, so that 
> a mis-use of "port" would have caused a compile error.
> 
> I'm not seeing anything obvious. Alan obviously found one bug already.

Thanks for checking. I'll try any debug patch from Alan.

	Ingo
