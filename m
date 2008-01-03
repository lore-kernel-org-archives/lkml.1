Return-Path: <linux-kernel-owner+w=401wt.eu-S1756385AbYACKsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385AbYACKsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 05:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbYACKsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 05:48:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45835 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbYACKsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 05:48:06 -0500
Date: Thu, 3 Jan 2008 11:47:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] [5/20] x86: Introduce nsec_barrier()
Message-ID: <20080103104754.GD29194@elte.hu>
References: <20080103149.088038000@suse.de> <20080103005000.65D0C14D40@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080103005000.65D0C14D40@wotan.suse.de>
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


* Andi Kleen <ak@suse.de> wrote:

> nsec_barrier() is a new barrier primitive that stops RDTSC speculation 
> to avoid races with timer interrupts on other CPUs.
> 
> Add it to all architectures. Except for x86 it is a nop right now. I 
> only tested x86, but it's a very simple change.
> 
> On x86 it expands either to LFENCE (for Intel CPUs) or MFENCE (for AMD 
> CPUs) which stops RDTSC on all currently known microarchitectures that 
> implement SSE. On CPUs without SSE there is generally no RDTSC 
> speculation.

i've picked up your rdtsc patches into x86.git but have simplified it: 
there's no nsec_barrier() anymore - rdtsc() is always synchronous. 
MFENCE/LFENCE is fast enough. Open-coding such barriers almost always 
leads to needless trouble. Please check the next x86.git tree.

	Ingo
