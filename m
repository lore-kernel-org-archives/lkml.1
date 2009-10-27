Return-Path: <linux-kernel-owner+w=401wt.eu-S1754991AbZJ0Nua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbZJ0Nua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 09:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754674AbZJ0Nu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 09:50:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59063 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754598AbZJ0Nu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 09:50:29 -0400
Date: Tue, 27 Oct 2009 14:50:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: lethal@linux-sh.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Kill off -Wcast-align
Message-ID: <20091027135025.GC32628@elte.hu>
References: <20091026054000.GA13517@linux-sh.org> <20091026062520.GA29580@elte.hu> <20091026094729.GB13517@linux-sh.org> <20091026.154055.07992945.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091026.154055.07992945.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> From: Paul Mundt <lethal@linux-sh.org>
> Date: Mon, 26 Oct 2009 18:47:30 +0900
> 
> > On Mon, Oct 26, 2009 at 07:25:20AM +0100, Ingo Molnar wrote:
> >> 
> >> * Paul Mundt <lethal@linux-sh.org> wrote:
> >> 
> >> > The present use of -Wcast-align causes the build to blow up on SH due to
> >> > generating a "cast increases required alignment of target type" error on
> >> > each invocation of list_for_each_entry().
> >> > 
> >> > It seems that this was previously reported and killed off in the ia64
> >> > support patch, but nothing seems to have happened with that. Presumably
> >> > the same problem still remains there, too.
> >> > 
> >> > Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> >> 
> >> Is this a GCC bug producing false positive warnings? The GCC manpage 
> >> says:
> >> 
> >>        -Wcast-align
> >>            Warn whenever a pointer is cast such that the required alignment of the
> >>            target is increased.  For example, warn if a "char *" is cast to an
> >>            "int *" on machines where integers can only be accessed at two- or
> >>            four-byte boundaries.
> >> 
> >> Which looks moderately useful - if it works.
> >> 
> > Well, both ia64 and sh have hit this in the current compilers, and it
> > doesn't seem to pose any code generation issues. In the areas where it is
> > generated it seems to relate to 64-bit data types in the data structures,
> > which in itself doesn't seem inherently problematic.
> 
> sparc64 hits this too when building 32-bit perf binary, the first 
> thing I do after a pull is remove this warning option from the 
> Makefile :-)

Generally if you run into such issues in Sparc let us know so we can fix 
it :-)

Paul's fix is queued up for Linus.

	Ingo
