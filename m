Return-Path: <linux-kernel-owner+w=401wt.eu-S1758561AbYKWTFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758561AbYKWTFE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 14:05:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbYKWTEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 14:04:52 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36296 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532AbYKWTEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 14:04:51 -0500
Date: Sun, 23 Nov 2008 20:04:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: jia zhang <jia.zhang2008@gmail.com>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, hpa@zytor.com
Subject: Re: [PATCH] x86: remove the confusing entry in call trace
Message-ID: <20081123190444.GE21106@elte.hu>
References: <49296CEE.2070905@gmail.com> <20081123173058.GA32147@mailshack.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123173058.GA32147@mailshack.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Alexander van Heukelum <heukelum@mailshack.com> wrote:

> On Sun, Nov 23, 2008 at 10:47:10PM +0800, jia zhang wrote:
> > 
> > avoid the confusion in call trace because of the lack of padding at the tail of
> > function.
> > 
> > Signed-off-by: jia zhang <jia.zhang2008@gmail.com> --- When do_exit get call,
> > the return address behind call instruction is pushed into stack. If something
> > get wrong in do_exit, for x86_64, the entry "kernel_execve +0x00/0xXX" rather
> > than "child_rip +0xYY/0xZZ" is remained in call trace. It looks confused.
> 
> It's valuable to know from where do_exit is called, so that's the
> only reason why using "call" is important. Otherwise it could just
> be changed to a jmp as do_exit does not return. It's maybe a bit
> ugly to add the padding, but it does give better traces. Maybe
> a 'ret', 'int3', or 'ud2' would be slightly less offensive?
> 
> Anyhow, I don't have a problem with the added padding, so:
> 
> Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>

applied to tip/x86/debug, thanks guys!

i changed it to u2d based on your suggestion - that makes it not only 
easier to understand, but also more robust, should do_exit() return. 
(which it should never in practice)

	Ingo
