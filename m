Return-Path: <linux-kernel-owner+w=401wt.eu-S1753493AbYGLFze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbYGLFze (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 01:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795AbYGLFzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 01:55:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49490 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730AbYGLFzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 01:55:23 -0400
Date: Sat, 12 Jul 2008 07:54:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       grundler@parisc-linux.org, tglx@linutronix.de, jgarzik@pobox.com,
       linux-ide@vger.kernel.org, suresh.b.siddha@intel.com,
       benh@kernel.crashing.org, jbarnes@virtuousgeek.org,
       rdunlap@xenotime.net, mtk.manpages@gmail.com, ebiederm@xmission.com,
       Matthew Wilcox <willy@linux.intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH 6/6] x86-64: Support for multiple MSIs
Message-ID: <20080712055444.GA13420@elte.hu>
References: <20080711211559.GV14894@parisc-linux.org> <1215811018-15270-6-git-send-email-matthew@wil.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215811018-15270-6-git-send-email-matthew@wil.cx>
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


* Matthew Wilcox <matthew@wil.cx> wrote:

> Add support for allocating an aligned block of interrupt vectors. 
> Allow interrupts to have up to 32 subchannels. Implement the 
> arch_setup_msi_irqs() and arch_teardown_msi_irqs() interfaces.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> ---
>  arch/x86/kernel/io_apic_64.c |  221 +++++++++++++++++++++++++++++++++++------
>  arch/x86/kernel/irq_64.c     |    2 +-
>  include/asm-x86/irq_64.h     |    2 +
>  3 files changed, 191 insertions(+), 34 deletions(-)

hm, please implement this symmetrically on 64-bit and 32-bit as well. 
That will need more IRQ infrastructure changes but that should be OK as 
it will reduce the gap between the 32-bit and 64-bit side instead of 
widening it. A good starting point would be to unify/generalize the IRQ 
vector allocators. (and that would get most of what you need for 
multi-vector MSI)

	Ingo
