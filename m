Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753264AbYLRVGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbYLRVGs (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 16:06:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbYLRVGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 16:06:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51462 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbYLRVGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 16:06:36 -0500
Date: Thu, 18 Dec 2008 22:06:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: sigframe.h: add guard macro
Message-ID: <20081218210628.GC24271@elte.hu>
References: <4949B9B5.2050701@ct.jp.nec.com> <20081218102934.GC10513@elte.hu> <494A85EB.9010505@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <494A85EB.9010505@ct.jp.nec.com>
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


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> Impact: cleanup
> 
> Add missing guard macro _ASM_X86_SIGFRAME_H.
> 
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> ---
> I forgot include guard:)
> 
>  arch/x86/include/asm/sigframe.h |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)

applied, thanks!

It didnt matter in practice yet, because all uses of sigframe.h were 
single-instance and were done in flat .c files, not in .h files:

 ./arch/x86/kernel/asm-offsets_32.c:#include "sigframe.h"
 ./arch/x86/kernel/signal_32.c:#include "sigframe.h"
 ./arch/x86/kernel/signal_64.c:#include "sigframe.h"
 ./arch/x86/ia32/ia32_signal.c:	struct _fpstate_ia32 fpstate_unused; /* look at kernel/sigframe.h */

but indeed it's better to have this fixed - just in case we put sigframe.h 
into an include file.

	Ingo
