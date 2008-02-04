Return-Path: <linux-kernel-owner+w=401wt.eu-S1752718AbYBDKvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbYBDKvp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 05:51:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751132AbYBDKve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 05:51:34 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35951 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750892AbYBDKvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 05:51:33 -0500
Date: Mon, 4 Feb 2008 02:51:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: schwidefsky@de.ibm.com
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 2/3] CONFIG_HIGHPTE vs. sub-page page tables.
Message-Id: <20080204025133.511ac3e2.akpm@linux-foundation.org>
In-Reply-To: <1202121409.31801.7.camel@localhost>
References: <20071112143009.425807965@de.ibm.com>
	<20071112144009.831296895@de.ibm.com>
	<20080201151541.8e3e0359.akpm@linux-foundation.org>
	<1202017020.7208.2.camel@pasglop>
	<20080202215315.3ac6907d.akpm@linux-foundation.org>
	<1202121409.31801.7.camel@localhost>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Feb 2008 11:36:49 +0100 Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> On Sat, 2008-02-02 at 21:53 -0800, Andrew Morton wrote:
> > On Sun, 03 Feb 2008 16:37:00 +1100 Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> > 
> > > Why dropping add-mm-argument-to-pte-pmd-pud-pgd_free.patch though ?
> > 
> > I dropped the whole series.
>
> Sniff .. my patches .. ;-)

Well yes.  People who merge via -mm continue to be at a disadvantage
because they're forced to go behind all the subsystem trees.  Plus I (and
apparently I alone) will skip patches when the kernel is
more-than-usually-wrecked and will slow things down for stabilisation as
we're heading into the merge window.

Plus: I started to prepare 2.6.24-mm1 on Friday morning, worked all weekend
and got it out Sunday evening after having committed forty to fifty fixes
and having dropped numerous patches.

If this situation (conflicting changes and poor code quality) persists into
the 2.6.25 cycle I will toss all the subsystem trees out of -mm, shall
rebase -mm on mainline and shall merge first.  I had decided today to
actually just do this, but on reflection I'll give it just one more shot.

It's remarkable how many bugs are in current mainline which weren't in
2.6.24-rc8-mm1.  What could have caused this?

> > Look: I can't fix *everyone's* stuff.  This was a consequence of ongoing
> > unbounded churn in the x86 tree.  If we can find a way of preventing those
> > guys (and everyone else) from trashing everyone else's stuff then we'd have
> > much smoother sailing.
> 
> Understood. That is where I jump in and regenerate my patches on the
> latest available level. That the patches did hold up for some months in
> -mm now without really breaking anything is an indication that we can
> push them upstream now, isn't ? That would make the patch problem go
> away and I could queue my s390 specific page table rework. Our KVM
> people keep asking about it.

yes, against 2.6.24-mm1 would be good, thanks.  I really don't know what
went wrong in i386 but I ended up getting all grumpy at the macro mess
we've made in all the pagetable handling.  Please do take a look at
improving that.


(goes back to bisecting)
