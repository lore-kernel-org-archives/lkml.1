Return-Path: <linux-kernel-owner+w=401wt.eu-S1754724AbYCYNGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbYCYNGY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 09:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753365AbYCYNGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 09:06:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35607 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335AbYCYNGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 09:06:14 -0400
Date: Tue, 25 Mar 2008 14:05:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: jirislaby@gmail.com, viro@ZenIV.linux.org.uk, joe@perches.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 109/148] include/asm-x86/serial.h: checkpatch cleanups
	- formatting only
Message-ID: <20080325130557.GA9612@elte.hu>
References: <47E64BF7.4070808@gmail.com> <20080323.053037.144236584.davem@davemloft.net> <20080325084457.GA32103@elte.hu> <20080325.024204.175042056.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080325.024204.175042056.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> I can tell you one more example of things I strongly disagree with 
> that it does, for example, such as telling me how to document 
> spinlocks in datastructures.
> 
> It wants a comment right above the spinlock_t member, but this totally 
> ignores that perhaps I put a huge comment explaining the locking 
> semantics elsewhere.

firstly, this warning from checkpatch.pl is off by default.

There are 3 checkpatch warning categories: ERROR, WARNING, CHECK. 
spinlock_t without a warning is in this third category and you wont even 
see that warning unless you very explicitly do:

    checkpatch.pl --subjective

Secondly, even about this "checkpatch.pl --subjective" check you are 
wrong. As someone who had to decode (way!) too many lockdep backtraces 
in various kernel code that i didnt author and didnt maintain, i can 
tell it you with very strong authority that even in this case it's a 
minimum requirement to put a comment right to that lock:

 /*
  * Regarding the locking rules, see the big comment block above in
  * this file:
  */

or:

 /* See net/core/sock.c for the locking rules: */

_Way_ too many times do i have to wonder where the heck a given lock is 
documented. You _wrote_ and maintain a good portion of that code, so to 
you it's seemingly an annoyance and nuisance. To everyone else, it's 
must-have information. Locks are at the heart of kernel data structures, 
not having at least a minimal pointer at them is really bad.

(sidenote: the scheduler has one deficiency there and i've fixed it in 
my tree. this warning should be moved from the 'check' category into the 
warning category.)

	Ingo
