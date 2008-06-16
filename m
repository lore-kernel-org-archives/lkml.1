Return-Path: <linux-kernel-owner+w=401wt.eu-S1755464AbYFPSuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbYFPSuz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 14:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbYFPSup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 14:50:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49777 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970AbYFPSuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 14:50:44 -0400
Date: Mon, 16 Jun 2008 20:49:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hugh Dickins <hugh@veritas.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@linux-foundation.or>,
       LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, Zachary Amsden <zach@vmware.com>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1 of 4] mm: add a ptep_modify_prot transaction
	abstraction
Message-ID: <20080616184949.GA14182@elte.hu>
References: <b020e42384197b824320.1213615800@localhost> <alpine.LFD.1.10.0806161028080.2949@woody.linux-foundation.org> <Pine.LNX.4.64.0806161906490.19564@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0806161906490.19564@blonde.site>
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


* Hugh Dickins <hugh@veritas.com> wrote:

> On Mon, 16 Jun 2008, Linus Torvalds wrote:
> > On Mon, 16 Jun 2008, Jeremy Fitzhardinge wrote:
> > >
> > > ptep_modify_prot_start() returns the current pte value, and puts the
> > >   pte entry into a state where either the hardware will not update the
> > >   pte, or if it does, the updates will be preserved on commit.
> > > 
> > > ptep_modify_prot_commit() writes back the updated pte, makes sure that
> > >   any hardware updates made since ptep_modify_prot_start() are
> > >   preserved.
> > 
> > Ok, I'm fine with this now that it's renamed to be clearly about just 
> > protection bits.
> > 
> > So 
> > 
> > 	Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> And seems very reasonable (and exceptionally well described) to me too.
> 
> 	Acked-by: Hugh Dickins <hugh@veritas.com>

thanks guys, i've added the Acked-by's and added a new -tip topic for 
this.

The dependencies are a bit tricky and the changes contain mm/ and 
include/asm-generic/ bits so lets try a new Git trick here to keep it 
all tidy and disciplined for v2.6.27 merging.

So i've created a new tip/mm/xen topic branch (the 85th -tip topic 
branch ;-), which is COW-ed off the current tip/x86/xen topic branch [on 
which branch these changes have some dependencies], and added these 4 
changes to that. The tip/x86/xen (append-only-) topic will continue to 
advance as usual, and we likely wont have dependencies on the stuff in 
tip/mm/xen. (if there will be such dependencies we can handle that too)

In v2.6.27 we can then offer up the two branches separately for upstream 
merge, and tip/x86/xen will still only have x86 and xen changes, not any 
mm changes. (Obviously tip/mm/xen will be offered after tip/x86/xen has 
gone upstream - so that it will only contain these 4 patches ontop of 
already-upstream changes)

it will all be auto-merged into linux-next so there this internal 
structure is not visible, all the changes are available for wide testing 
of course.

i've added these mm/ changes to auto-core-next (not auto-x86-next), if 
that is fine by Andrew.

	Ingo
