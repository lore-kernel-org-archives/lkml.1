Return-Path: <linux-kernel-owner+w=401wt.eu-S1756863AbXKRBEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbXKRBEi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 20:04:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754151AbXKRBEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 20:04:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50035 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753550AbXKRBE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 20:04:29 -0500
Date: Sun, 18 Nov 2007 02:04:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       tglx@tglx.de
Subject: Re: [patch] Printk kernel version in WARN_ON
Message-ID: <20071118010408.GE26865@elte.hu>
References: <20071117101552.2a7f34cb@laptopd505.fenrus.org> <20071117102720.251107d7.akpm@linux-foundation.org> <20071117103947.5b2052f8@laptopd505.fenrus.org> <20071117104652.8240af62.akpm@linux-foundation.org> <20071117113501.5e3e0d43@laptopd505.fenrus.org> <20071118004218.GA26865@elte.hu> <20071117165719.c8d7bb48.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071117165719.c8d7bb48.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> Should be done for all architectures, methinks.
> 
> If so, an appropriate way to do that would be to do 
> s/dump_stack/arch_dump_stack/ and do a single all-arch implementation 
> of dump_stack().  (Where we might add new goodies in the future).

i agree we can clean this up - but this is a single-line thing that is 
very useful for QA so i think utility warrants .24 inclusion. The oops 
printouts are not generalized anyway.

> Problem is that this will add a new an pointless entry to all the 
> stack dumps, unless the arch_dump_stack() implementation is smart 
> enough to skip the innermost frame.

x86 can skip stackframes via stacktrace.c.

	Ingo
