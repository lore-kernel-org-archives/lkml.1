Return-Path: <linux-kernel-owner+w=401wt.eu-S1757304AbYAVMsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbYAVMsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 07:48:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbYAVMsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 07:48:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40473 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbYAVMs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 07:48:29 -0500
Date: Tue, 22 Jan 2008 13:48:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: travis@sgi.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] x86: Reduce memory usage for large count NR_CPUs
	fixup V2 with git-x86
Message-ID: <20080122124811.GD7304@elte.hu>
References: <20080121211618.599818000@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080121211618.599818000@sgi.com>
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


* travis@sgi.com <travis@sgi.com> wrote:

> Fixup change NR_CPUS patchset by rebasing on 2.6.24-rc8-mm1
> from 2.6.24-rc6-mm1) and adding changes suggested by reviews.
> 
> Based on 2.6.24-rc8-mm1 + latest (08/1/21) git-x86
> 
> Note there are two versions of this patchset:
> 	- 2.6.24-rc8-mm1
> 	- 2.6.24-rc8-mm1 + latest (08/1/21) git-x86

thanks, applied.

> Signed-off-by: Mike Travis <travis@sgi.com>
> ---
> Fixup-V2:
>     - pulled the SMP_MAX patch as it's not strictly needed and some
>       more work on local cpumask_t variables needs to be done before
>       NR_CPUS is allowed to increase.

i'd still love to see CONFIG_SMP_MAX, so that we can have continuous 
randconfig testing of the large-SMP aspects of the x86 architecture, 
even on smaller systems.

What's the maximum that should work right now? 256 or perhaps even 512 
CPU ought to work fine i think?

and then once the on-stack usage problems are fixed, the NR_CPUS value 
in CONFIG_SMP_MAX can be increased. So SMP_MAX would also act as "this 
is how far we can go in the upstream kernel" documentation.

[ btw., the crash i remember was rather related to the NODES_SHIFT
  increase to 9, not from the NR_CPUSs increase. (the config i sent 
  still has NR_CPUS==8, because Kconfig did not pick up the right 
  NR_CPUs value dicatated by SMP_MAX.) If you resend the SMP_MAX patch 
  against latest x86.git i can retest this. ]

	Ingo
