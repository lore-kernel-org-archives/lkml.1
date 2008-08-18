Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbYHROHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbYHROHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 10:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbYHROHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 10:07:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35077 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580AbYHROHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 10:07:21 -0400
Date: Mon, 18 Aug 2008 16:07:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       michael@free-electrons.com
Subject: Re: [PATCH] [x86] Move cmpxchg fallbacks to a generic place
Message-ID: <20080818140706.GB30511@elte.hu>
References: <20080815143843.GA519@elte.hu> <1219055602-8046-2-git-send-email-thomas.petazzoni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219055602-8046-2-git-send-email-thomas.petazzoni@free-electrons.com>
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


* Thomas Petazzoni <thomas.petazzoni@free-electrons.com> wrote:

> arch/x86/kernel/cpu/intel.c defines a few fallback functions
> (cmpxchg_*()) that are used when the CPU doesn't support cmpxchg
> and/or cmpxchg64 natively. However, while defined in an Intel-specific
> file, these functions are also used for CPUs from other vendors when
> they don't support cmpxchg and/or cmpxchg64. This breaks the
> compilation when support for Intel CPUs is disabled.
> 
> This patch moves these functions to a new
> arch/x86/kernel/cpu/cmpxchg.c file, unconditionally compiled when
> X86_32 is enabled.
> 
> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

applied both fixes to tip/x86/cpu, thanks Thomas.

I also flipped it around with the cpu-id reduction patch, so that it 
remains bisectable. The new commit IDs in -tip are:

8bfcb39: x86: make movsl_mask definition non-CPU specific
774400a: x86: move cmpxchg fallbacks to a generic place
8d02c21: x86: configuration options to compile out x86 CPU support code

	Ingo
