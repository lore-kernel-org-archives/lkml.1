Return-Path: <linux-kernel-owner+w=401wt.eu-S1757532AbZBXSwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532AbZBXSwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 13:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751807AbZBXSwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 13:52:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34911 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471AbZBXSwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 13:52:09 -0500
Date: Tue, 24 Feb 2009 19:52:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perfcounters/powerpc: Make exclude_kernel bit work on
	Apple G5 processors
Message-ID: <20090224185200.GA23109@elte.hu>
References: <18851.20328.847510.730956@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18851.20328.847510.730956@cargo.ozlabs.ibm.com>
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


* Paul Mackerras <paulus@samba.org> wrote:

> Currently, setting hw_event.exclude_kernel does nothing on the PPC970
> variants used in Apple G5 machines, because they have the HV (hypervisor)
> bit in the MSR forced to 1, so as far as the PMU is concerned, the
> kernel runs in hypervisor mode.  Thus we have to use the MMCR0_FCHV
> (freeze counters in hypervisor mode) bit rather than the MMCR0_FCS
> (freeze counters in supervisor mode) bit.
> 
> This checks the MSR.HV bit at startup, and if it is set, we set the
> freeze_counters_kernel variable to MMCR0_FCHV (it was initialized to
> MMCR0_FCS).  We then use that whenever we need to exclude kernel events.
> 
> Signed-off-by: Paul Mackerras <paulus@samba.org>
> ---
> Ingo, please pull this from my perfcounters.git tree master branch at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perfcounters.git master
> 
>  arch/powerpc/kernel/perf_counter.c |   23 ++++++++++++++++++-----
>  1 files changed, 18 insertions(+), 5 deletions(-)

pulled, thanks Paul!

	Ingo
