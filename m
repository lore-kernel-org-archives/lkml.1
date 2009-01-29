Return-Path: <linux-kernel-owner+w=401wt.eu-S1758037AbZA2WOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037AbZA2WOV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 17:14:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbZA2WOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 17:14:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55194 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbZA2WOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 17:14:11 -0500
Date: Thu, 29 Jan 2009 23:14:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tim Pepper <lnxninja@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: unify genapic code, unify subarchitectures, remove old
	subarchitecture code
Message-ID: <20090129221402.GA1984@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu> <87vdryw6ql.fsf@basil.nowhere.org> <eada2a070901291324t1a2dbb08hbff7b026c77d69cd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eada2a070901291324t1a2dbb08hbff7b026c77d69cd@mail.gmail.com>
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


* Tim Pepper <lnxninja@linux.vnet.ibm.com> wrote:

> The machines (yes plural!) on which we had regular testing happening 
> have been offline for a few months due to some broader dependencies (eg: 
> console server in the old product used an old version of windows that 
> doesn't meet the corporate security standards) and we've just not 
> managed to get past that.  That in turn is in the way of debugging boot 
> issues with newer kernels.  At this point the most passionate 
> Sequent/IBMers caring about the NUMAQ support are resigned to it being a 
> lost cause.
> 
> The main benefit to carrying NUMAQ support along this long was these 
> machines had a knack for triggering real bugs.  But since there's no 
> active bug testing happening on them now and it doesn't look like there 
> will be...

At this point there's no technical need to kill it - it's a zero-overhead 
thing tucked away into a single .c module in arch/x86/kernel/numaq_32.c. I 
even consolidated most of its headers in that file, to reduce its cross 
section.

That was the main point of the restructuring i did - subarchitectures were 
causing ongoing maintenance overhead before. That overhead is practically 
zero now.

So two days ago it might have made some sense to rip out this code - now 
there's no pressing need really. We can remove it in a few years once the 
last beep has been received from those platforms. The numaq code is now 
quite similar to an old driver in drivers/* - there's no real downside 
from having it around.

	Ingo
