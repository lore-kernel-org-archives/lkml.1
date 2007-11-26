Return-Path: <linux-kernel-owner+w=401wt.eu-S1756578AbXKZUqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578AbXKZUqt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 15:46:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754985AbXKZUql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 15:46:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36828 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754594AbXKZUqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 15:46:39 -0500
Date: Mon, 26 Nov 2007 21:45:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, kamalesh@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, apw@shadowen.org,
       balbir@linux.vnet.ibm.com, linux-acpi@vger.kernel.org,
       tglx@linutronix.de, Christoph Lameter <clameter@sgi.com>
Subject: Re: 2.6.24-rc3-mm1 - Kernel Panic on IO-APIC
Message-ID: <20071126204540.GA19874@elte.hu>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org> <4743CC0B.9000508@linux.vnet.ibm.com> <20071120221839.faab108e.akpm@linux-foundation.org> <20071126143943.0a01665b@cuia.boston.redhat.com> <20071126123319.7483e57f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071126123319.7483e57f.akpm@linux-foundation.org>
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
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 26 Nov 2007 14:39:43 -0500
> Rik van Riel <riel@redhat.com> wrote:
> 
> > On Tue, 20 Nov 2007 22:18:39 -0800
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > > ..MP-BIOS bug: 8254 timer not connected to IO-APIC
> > > > Kernel panic - not syncing: IO-APIC + timer doesn't work! Try using the 'noapic' kernel parameter
> > > 
> > > ACPI or x86 breakage, I guess.
> > > 
> > > Did 'noapic' work?
> > 
> > I got the same bug as above, 'noapic' gets past that point 
> 
> We still don't know what caused this, afaik.

yes. Is it a regression? If yes, could someone try to bisect it so that 
we can fix it? If it's caused by x86.git then the 'mm' branch of the x86 
git tree can be used for bisection:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

it's supposed to build and boot fine at every bisection point. The 
bisection run can be cut significantly by narrowing the bisection to the 
arch/x86 changes only:

  git-bisect start arch/x86 include/asm-x86/

(and if it finds a nonsensical commit, i.e. the breakage is not caused 
by the x86 commits, save the "git-bisect log" output into a file, 
restart the git bisection and use "git-bisect replay" to insert all the 
test points into a fuller bisection run - this saves quite some time.)

	Ingo
