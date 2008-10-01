Return-Path: <linux-kernel-owner+w=401wt.eu-S1753527AbYJAGuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbYJAGuU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 02:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbYJAGt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 02:49:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49243 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448AbYJAGtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 02:49:55 -0400
Date: Wed, 1 Oct 2008 08:49:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix: x86: remove cpu_vendor_dev
Message-ID: <20081001064942.GA651@elte.hu>
References: <1222792897-5691-1-git-send-email-heukelum@fastmail.fm> <20080930193736.GA4453@mailshack.com> <86802c440809301337i1bbf6e9ckb8de8a1ef08955d3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440809301337i1bbf6e9ckb8de8a1ef08955d3@mail.gmail.com>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> On Tue, Sep 30, 2008 at 12:37 PM, Alexander van Heukelum
> <heukelum@mailshack.com> wrote:
> > x86_64-kernels after commit 10a434fcb "x86: remove cpu_vendor_dev"
> > crashed on qemu-system-x86_64 due to a typo in vmlinux_64.lds.S.
> >
> > Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
> >
> > ---
> >
> > On Tue, Sep 30, 2008 at 06:41:33PM +0200, Alexander van Heukelum wrote:
> >> Moreover, a defconfig won't run :-/ (on qemu-system-x86_64).
> >> Bisection pointed to commit 10a434fcb "x86: remove cpu_vendor_dev".
> >> The kernel crashes early with a general protection fault in a call
> >> to strnlen. I have no idea what goes wrong, yet.
> >
> > It took quite some time, but I found the problem... I'll leave
> > the other one to you ;).
> >
> > Greetings,
> >        Alexander
> >
> >  arch/x86/kernel/vmlinux_64.lds.S |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
> > index 201e81a..46e0544 100644
> > --- a/arch/x86/kernel/vmlinux_64.lds.S
> > +++ b/arch/x86/kernel/vmlinux_64.lds.S
> > @@ -172,8 +172,8 @@ SECTIONS
> >   .x86_cpu_dev.init : AT(ADDR(.x86_cpu_dev.init) - LOAD_OFFSET) {
> >        *(.x86_cpu_dev.init)
> >   }
> > -  SECURITY_INIT
> >   __x86_cpu_dev_end = .;
> > +  SECURITY_INIT
> >
> >   . = ALIGN(8);
> >   .parainstructions : AT(ADDR(.parainstructions) - LOAD_OFFSET) {
> >
> 
> that is merging problem, Ingo should fix that already...

indeed. I've fixed it in tip/x86/traps by applying Alexander's patch.

	Ingo
