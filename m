Return-Path: <linux-kernel-owner+w=401wt.eu-S1753671AbZHTKHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671AbZHTKHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 06:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753097AbZHTKHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 06:07:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48666 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022AbZHTKHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 06:07:17 -0400
Date: Thu, 20 Aug 2009 12:06:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [GIT PULL] Fix Xen boot with CONFIG_CC_STACKPROTECTOR
Message-ID: <20090820100644.GC29093@elte.hu>
References: <4A8C98DD.2020709@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8C98DD.2020709@goop.org>
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
> Here's a couple of little changes which prevents an early boot crash
> under Xen, due to the stackprotector preamble using segment registers
> before they're set up.  I only need to disable stackprotector for a
> handful of functions, but unfortunately it looks like it can only be
> disabled on a per-file basis.
> 
> Thanks,
>     J
> 
> The following changes since commit 64f1607ffbbc772685733ea63e6f7f4183df1b16:
>   Linus Torvalds (1):
>         Linux 2.6.31-rc6
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git bugfix
> 
> Jeremy Fitzhardinge (2):
>       x86: make sure load_percpu_segment has no stackprotector
>       xen: rearrange things to fix stackprotector
> 
>  arch/x86/kernel/cpu/Makefile |    4 ++++
>  arch/x86/xen/Makefile        |    4 ++++
>  arch/x86/xen/enlighten.c     |   22 ++++++++++------------
>  3 files changed, 18 insertions(+), 12 deletions(-)

Pulled into tip:x86/urgent, thanks a lot Jeremy!

Btw., is there any way to turn off stackprotector on a 
per function basis, a GCC attribute perhaps? That would 
be preferable to turning it off for all of common.o.

	Ingo
