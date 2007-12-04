Return-Path: <linux-kernel-owner+w=401wt.eu-S1753651AbXLDW1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651AbXLDW1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 17:27:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbXLDW1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 17:27:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57531 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625AbXLDW1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 17:27:33 -0500
Date: Tue, 4 Dec 2007 23:27:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] x86: Unify include/asm-x86/linkage_[32|64].h
Message-ID: <20071204222717.GA25974@elte.hu>
References: <1196801629.10408.26.camel@brick> <20071204213247.GA11216@elte.hu> <1196806868.10408.33.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1196806868.10408.33.camel@brick>
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


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> On Tue, 2007-12-04 at 22:32 +0100, Ingo Molnar wrote:
> > * Harvey Harrison <harvey.harrison@gmail.com> wrote:
> > 
> > > I'm not sure if the definition of asmlinkage and prevent_tail_call can 
> > > be omitted as well and let the linux/linkage.h version get picked up 
> > > instead.
> > 
> > no, we cannot remove them - asmlinkage is needed for the syscall 
> > entry (and other entry code) to work, the and the prevent_tail_call 
> > works around a compiler bug. (which might or might not be fixed in 
> > latest gcc - but we generally dont remove workarounds unless we are 
> > really sure it's fine.)
> 
> OK, but if this patch is acceptable, then there is no more places in 
> the tree that define the FASTCALL macro, other than the empty default 
> in include/linux/linkage.h.  So I think a second step would be to 
> start to get rid of FASTCALL callers elsewhere in the tree...thoughts?

the removal of FASTCALL is fine: the default (and only) compiler model 
for x86 (32-bit) is regparm(3), so the regparm(3) macro is equivalent to 
the empty one in linux/linkage.h.

btw., removal of FASTCALL from the tree is worthwile after this: it 
should probably be done via the -mm tree, because it's more of a generic 
kernel matter than an arch/x86 matter.

	Ingo
