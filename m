Return-Path: <linux-kernel-owner+w=401wt.eu-S1754401AbYL0Klw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401AbYL0Klw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 05:41:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbYL0Klo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 05:41:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58517 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799AbYL0Kln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 05:41:43 -0500
Date: Sat, 27 Dec 2008 11:41:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Brian Gerst <brgerst@gmail.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Alexander van Heukelum <heukelum@mailshack.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86-64: Convert the PDA to percpu.
Message-ID: <20081227104123.GH14639@elte.hu>
References: <1230052506-5041-1-git-send-email-brgerst@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230052506-5041-1-git-send-email-brgerst@gmail.com>
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


(Cc:-ed a few more people who might be interested in this)

* Brian Gerst <brgerst@gmail.com> wrote:

> This patch makes the PDA a normal per-cpu variable, allowing the
> removal of the special allocator code.  %gs still points to the
> base of the PDA.
> 
> Tested on a dual-core AMD64 system.
> 
> Signed-off-by: Brian Gerst <brgerst@gmail.com>
> ---
>  arch/x86/include/asm/pda.h     |    3 --
>  arch/x86/include/asm/percpu.h  |    3 --
>  arch/x86/include/asm/setup.h   |    1 -
>  arch/x86/kernel/cpu/common.c   |    6 ++--
>  arch/x86/kernel/dumpstack_64.c |    8 ++--
>  arch/x86/kernel/head64.c       |   23 +------------
>  arch/x86/kernel/irq.c          |    2 +-
>  arch/x86/kernel/nmi.c          |    2 +-
>  arch/x86/kernel/setup_percpu.c |   70 ++++++++--------------------------------
>  arch/x86/kernel/smpboot.c      |   58 +--------------------------------
>  arch/x86/xen/enlighten.c       |    2 +-
>  arch/x86/xen/smp.c             |   12 +------
>  12 files changed, 27 insertions(+), 163 deletions(-)

the simplification factor is significant. I'm wondering, have you measured 
the code size impact of this on say the defconfig x86 kernel? That will 
generally tell us how much worse optimizations the compiler does under 
this scheme.

	Ingo
