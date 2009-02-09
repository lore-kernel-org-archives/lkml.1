Return-Path: <linux-kernel-owner+w=401wt.eu-S1755021AbZBIKak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021AbZBIKak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 05:30:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308AbZBIKaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 05:30:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34156 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635AbZBIKaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 05:30:07 -0500
Date: Mon, 9 Feb 2009 11:29:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [GIT PULL] x86: unify some of kernel/irq*.c
Message-ID: <20090209102951.GK20467@elte.hu>
References: <498CD661.4070804@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498CD661.4070804@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> These changes factor out the differences between 32 and 64-bit do_IRQ  
> and unify the rest. Unfortunately there are still quite a few other  
> differences (like interrupt stack handling) which preclude further easy  
> unification.
>
> Thanks,
>    J
>
> The following changes since commit f21daa4d04885a34d1972afa9f82a8aebb6152bb:
>  Ingo Molnar (1):
>        Merge branch 'out-of-tree'
>
> are available in the git repository at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git jsgf/x86/unify-irq
>
> Jeremy Fitzhardinge (2):
>      x86: add handle_irq() to allow interrupt injection

Why doesnt Xen use a special irqchip, instead of this private hook/layer
in the lowlevel x86 arch level?

irqchip is at least well-specified and widely used. do_IRQ() internals
on the other hand will become a Xen special quickly. Also, adding a
needless function call there obviously does not help native performance.

	Ingo
