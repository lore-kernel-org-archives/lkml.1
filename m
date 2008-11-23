Return-Path: <linux-kernel-owner+w=401wt.eu-S1758135AbYKWTAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135AbYKWTAu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 14:00:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbYKWTAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 14:00:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36154 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbYKWTAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 14:00:41 -0500
Date: Sun, 23 Nov 2008 20:00:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] x86: introduce ENTRY(KPROBE)_X86  assembly helpers
	to catch unbalanced declaration
Message-ID: <20081123190025.GD21106@elte.hu>
References: <20081123165711.GA12710@localhost> <20081123175125.GA32472@uranus.ravnborg.org> <20081123175846.GF12710@localhost> <20081123181248.GA338@uranus.ravnborg.org> <20081123182103.GH12710@localhost> <20081123185417.GA21106@elte.hu> <20081123185726.GL12710@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123185726.GL12710@localhost>
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> [Ingo Molnar - Sun, Nov 23, 2008 at 07:54:17PM +0100]
> | 
> | * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> | 
> | > [Sam Ravnborg - Sun, Nov 23, 2008 at 07:12:48PM +0100]
> | > ...
> | > | > 
> | > | > I don't have -next tree on my laptop, neither cross-compile tools but
> | > | > if someone could test it -- it would be great. But I used gas macros
> | > | > here -- i doubt other architectures has the same syntax. At least
> | > | > PDP-11 would beat us with ';' symbol :)
> | > | 
> | > | If we include this in any of the 100+ trees that Stephen sucks
> | > | into -next we will get it tried out.
> | > | 
> | > | Ingo has so and so does others so getting it into -next
> | > | is rather easy. Then the automated builds will tell of if
> | > | it fails on any of the toolchains used there.
> | > | 
> | > | 	Sam
> | > | 
> | > 
> | > Sam, to be clear, you mean that I could put this stuff into general 
> | > include/linux/linkage.h with general names as ENTRY/END and the same 
> | > for KPROBE so it could be merged into -next tree for testing? If 
> | > yes, that as I said there will be a lot of errors so build will 
> | > stuck in a moment 'cause of unbalanced ENTRY. Not sure if it's a 
> | > good idea :)
> | 
> | neither do i think it's a particularly good idea. Lets first prototype 
> | it on x86, see how it works out in practice, and then see whether it 
> | can be generic. Then it can just be lifted into the generic linkage.h 
> | separately, and we can then see whether it causes new problems. 
> | 
> | 	Ingo
> | 
> 
> So be it :) Btw I think Alexander is right -- better to use .warning 
> instead of .error (and without .abort) even on x86. Could you update 
> Ingo?

.error is perfectly fine because that way automated tests that we do 
on -tip will catch any bugs, we really dont want to mis-annotate these 
things. Warnings tend to only pile up and rarely get fixed - without 
enforcement mechanism that causes people to fix them.

	Ingo
