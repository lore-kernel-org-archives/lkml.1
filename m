Return-Path: <linux-kernel-owner+w=401wt.eu-S1755464AbZJSHau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbZJSHau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 03:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755405AbZJSHau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 03:30:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54100 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755397AbZJSHat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 03:30:49 -0400
Date: Mon, 19 Oct 2009 09:30:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 3/2] perf tools: Use DECLARE_BITMAP instead of an
	open-coded array
Message-ID: <20091019073039.GC17960@elte.hu>
References: <20091016074222.GD30019@elte.hu> <1255795038-13751-1-git-send-email-fweisbec@gmail.com> <20091017160338.GA10344@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091017160338.GA10344@nowhere>
User-Agent: Mutt/1.5.19 (2009-01-05)
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Sat, Oct 17, 2009 at 05:57:18PM +0200, Frederic Weisbecker wrote:
> > Use DECLARE_BITMAP instead of an open coded array for our bitmap
> > of featured sections.
> > 
> > This makes the array an unsigned long instead of a u64 but since we 
> > use a 256 bits bitmap, the array size shouldn't vary between 
> > different boxes.
> 
> That said I would really feel more comfortable if someone can confirm 
> that.

Should be size-invariant for the bitmap size of 256 bits due to:

#define DECLARE_BITMAP(name,bits) \
        unsigned long name[BITS_TO_LONGS(bits)]

but it's not little-endian/big-endian invariant.

We should at minimum save the CPU architecture (and endianness 
parameters) the data got generated on, and reject 
endianness-incompatible uses - so that if someone wants to add 
cross-endian support it can be implemented cleanly.

	Ingo
