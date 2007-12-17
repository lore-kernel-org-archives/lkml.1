Return-Path: <linux-kernel-owner+w=401wt.eu-S1761987AbXLQOxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761987AbXLQOxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 09:53:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578AbXLQOxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 09:53:36 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33354 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909AbXLQOxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 09:53:35 -0500
Date: Mon, 17 Dec 2007 15:53:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: tglx@linutronix.de, Andrew Morton <akpm@linux-foundation.org>,
       mingo@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86-64: make pda's cpunumber and nodenumber unsigned
Message-ID: <20071217145317.GD16604@elte.hu>
References: <47610530.76E4.0078.0@novell.com> <20071217132619.GB1870@elte.hu> <476689AF.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476689AF.76E4.0078.0@novell.com>
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


* Jan Beulich <jbeulich@novell.com> wrote:

> > good catch! Applied your patch to x86.git - queued it up for 
> > v2.6.25. I bet there are tons of other instances where we use signed 
> > instead of unsigned and get worse code generation.
> 
> Yes, definitely. This patch was kind of a testing one whether this is 
> a welcome change. As it appears to be, I'll probably produce more as I 
> run into respective cases.

they are definitely welcome! Especially when fields are also used in 
integer multiplications or divisions then the cost of signedness can be 
quite significant. We regularly do such int -> uint sweeps in the 
scheduler code and it's a great code size reductor.

Btw., a sidenote: if you are touching files that you care about, and if 
you've got a few spare cycles, you might also want to take a look at 
checkpatch.pl output:

 $ scripts/checkpatch.pl --file include/asm-x86/pda.h
 ...
 total: 23 errors, 1 warnings, 133 lines checked

as it might have a few low hanging fruits ripe for cleanup ;-)

	Ingo

