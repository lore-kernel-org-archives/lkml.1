Return-Path: <linux-kernel-owner+w=401wt.eu-S1760555AbZEGO2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760555AbZEGO2Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 10:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbZEGO2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 10:28:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56524 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbZEGO2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 10:28:06 -0400
Date: Thu, 7 May 2009 16:27:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: akpm@linux-foundation.org, greg@kroah.com, norsk5@yahoo.com,
       tglx@linutronix.de, hpa@zytor.com, mchehab@redhat.com, aris@redhat.com,
       edt@aei.ca, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/21 v3] amd64_edac: EDAC module for AMD64
Message-ID: <20090507142724.GM481@elte.hu>
References: <1241704183-29223-1-git-send-email-borislav.petkov@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241704183-29223-1-git-send-email-borislav.petkov@amd.com>
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


* Borislav Petkov <borislav.petkov@amd.com> wrote:

> Hi,
> 
> here's v3 of the EDAC module for AMD k8, Fam10h and Fam11h processors.
> Among the changes from the previous version are a split of the
> driver into several .c files based on functionality, removal of
> StinkyIdentifiers and bunch of cleanups all over the place.
> 
> Thanks again to all the reviewers for their constructive comments, as
> always give it a good stare and flame away :).
> 
> There's also a git repo with the patchset based on Linus' branch from
> yesterday:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/bp/amd64_edac.git
> 
> Changelog:
> 
> - v2:
> Highlights are the addition of two helpers to read/write MSRs on several
> CPUs, denoted by a cpumask and using an array of MSR values per-CPU, as
> hpa suggested. Since IMHO they look generic enough I've added them to
> arch/x86/lib/msr-on-cpu.c (now renamed to msr.c).
> 
> Thanks,
> Boris.
> 
> 
>  arch/x86/include/asm/msr.h          |   21 +
>  arch/x86/lib/Makefile               |    2 +-
>  arch/x86/lib/msr-on-cpu.c           |   97 -
>  arch/x86/lib/msr.c                  |  152 ++
>  drivers/edac/Kconfig                |   26 +
>  drivers/edac/Makefile               |   13 +
>  drivers/edac/amd64_edac.c           | 3759 +++++++++++++++++++++++++++++++++++
>  drivers/edac/amd64_edac.h           |  951 +++++++++
>  drivers/edac/amd64_edac_dbg.c       |  291 +++
>  drivers/edac/amd64_edac_err_types.c |  163 ++
>  drivers/edac/amd64_edac_inj.c       |  203 ++
>  11 files changed, 5580 insertions(+), 98 deletions(-)

Regarding workflow, the arch/x86 bits look good to me now, so you've 
got my Acked-by for that. Most of the EDAC patches are hosted in 
-mm, so we could carry them in the x86 tree separately as well and 
export it to linux-next so that -mm will have it automatically.

	Ingo
