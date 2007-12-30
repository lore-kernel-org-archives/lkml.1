Return-Path: <linux-kernel-owner+w=401wt.eu-S1757563AbXL3Pqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563AbXL3Pqt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 10:46:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751588AbXL3Pql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 10:46:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55429 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbXL3Pqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 10:46:40 -0500
Date: Sun, 30 Dec 2007 16:45:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Jim Keniston <jkenisto@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: kprobes remove fix_riprel #ifdef
Message-ID: <20071230154544.GB10444@elte.hu>
References: <1198466917.6323.15.camel@brick> <47773CAD.7050907@redhat.com> <20071230132337.GF16946@elte.hu> <4777B0AA.9050503@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4777B0AA.9050503@redhat.com>
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


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Indeed.
> By the way, flush_cache_page() is defined as a do-while(0) on x86.
> Would it better to define fix_riprel() as a do-while(0) on x86-32?
> I think this obviously indicates that function has no effect.

NOPs should always be an inline. flush_cache_page()'s macro use is 
historic - feel free to send cleanup patches against cacheflush.h.

or even better, since most architectures dont need explicit 
cache-flushes, provide an asm-generic/cache_flush-nop.h file that is
#include-ed by asm-x86/cacheflush.h. (and by other architectures)

	Ingo
