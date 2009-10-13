Return-Path: <linux-kernel-owner+w=401wt.eu-S1759382AbZJMKbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759382AbZJMKbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 06:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756609AbZJMKbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 06:31:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48725 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754250AbZJMKbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 06:31:47 -0400
Date: Tue, 13 Oct 2009 12:30:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] x86: unify sys_iopl
Message-ID: <20091013103044.GA3915@elte.hu>
References: <4ABD3EC2.1020104@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ABD3EC2.1020104@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Hi Ingo,
> 
> The x86-64 implementation of iopl was buggy because it never ended up 
> calling set_iopl_mask().  This had no effect on native sys_iopl 
> (because set_iopl_mask is normally no-op on 64-bit), but it ended up 
> never calling the pvop, which caused iopl to have no effect on 64-bit 
> Xen guests.
> 
> The two functions are needlessly different anyway.  This patch just 
> unifies them into a single function which is mostly derived from the 
> 32-bit version.
> 
> Thanks,
> 	J
> 
> The following changes since commit c44c9ec0f38b939b3200436e3aa95c1aa83c41c7:
>   Jeremy Fitzhardinge (1):
>         x86: split NX setup into separate file to limit unstack-protected code
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git bugfix
> 
> Jeremy Fitzhardinge (1):
>       x86: unify sys_iopl
> 
>  arch/x86/include/asm/syscalls.h |    8 +++-----
>  arch/x86/kernel/ioport.c        |   11 ++---------
>  2 files changed, 5 insertions(+), 14 deletions(-)

Pulled, thanks a lot Jeremy!

It's in tip:x86/paravirt right now. I'm uneasy about pushing this into 
.32 - we had this status quo forever. Peter, Thomas, what do you think?

	Ingo
