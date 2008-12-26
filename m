Return-Path: <linux-kernel-owner+w=401wt.eu-S1754135AbYLZJPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbYLZJPm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 04:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205AbYLZJP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 04:15:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42218 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640AbYLZJP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 04:15:27 -0500
Date: Fri, 26 Dec 2008 10:15:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Remove interrupt stack table usage from x86_64
	kernel
Message-ID: <20081226091521.GD27747@elte.hu>
References: <1230238726-17506-1-git-send-email-avi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230238726-17506-1-git-send-email-avi@redhat.com>
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


* Avi Kivity <avi@redhat.com> wrote:

> The interrupt stack table (IST) mechanism is the only thing preventing
> kvm from deferring saving and reloading of some significant state.  It
> is also somewhat complicated.
> 
> Remove it by switching the special exceptions to use the normal irqstack.
> 
> Avi Kivity (3):
>   x86: drop the use of the tss interrupt stack table (IST)
>   x86: Remove pda.irqcount
>   x86: Switch critical exceptions and NMI to irqstack
> 
>  arch/x86/include/asm/desc.h      |   12 -----
>  arch/x86/include/asm/page_64.h   |    7 ---
>  arch/x86/include/asm/pda.h       |    2 +-
>  arch/x86/include/asm/processor.h |   11 ----
>  arch/x86/kernel/asm-offsets_64.c |    1 -
>  arch/x86/kernel/cpu/common.c     |   35 --------------
>  arch/x86/kernel/dumpstack_64.c   |   96 --------------------------------------
>  arch/x86/kernel/entry_64.S       |   49 ++++++++-----------
>  arch/x86/kernel/traps.c          |   12 ++--
>  9 files changed, 27 insertions(+), 198 deletions(-)

looks good. Please base your work on the tip/master tree, we have a ton of 
pending (and conflicting) changes in the lowlevel assembly area:

  http://people.redhat.com/mingo/tip.git/README

	Ingo
