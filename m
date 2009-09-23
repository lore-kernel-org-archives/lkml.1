Return-Path: <linux-kernel-owner+w=401wt.eu-S1751716AbZIWMf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716AbZIWMf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 08:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbZIWMf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 08:35:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58925 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbZIWMf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 08:35:58 -0400
Date: Wed, 23 Sep 2009 14:35:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@redhat.com>, the arch/x86 maintainers <x86@kernel.org>,
       Stable Kernel <stable@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [GIT PULL] xen: Check NX state before setting up GDT mapping
Message-ID: <20090923123527.GB19385@elte.hu>
References: <4AB7EC1D.5010102@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB7EC1D.5010102@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Hi Ingo,
> 
> This is a little followup fix to the previous Xen stack-protector
> patches to deal with the case of a 64-bit processor without NX support
> (either old Intel or disabled in BIOS).  Before creating the mapping for
> the GDT we need to make sure that NX is actually supported or the
> processor will fault on us.
> 
> This ends up making mm/init.o non-stack-protected.  Given that this file
> has some fairly complex functions with local arrays, I've made an
> additional change to move the NX setup into its own file to limit the
> non-stack-protected code.  I added it as a later delta so that the pure
> bugfix can be applied to stable, and the cleanup can go on top into
> mainline.
> 
> Thanks,
>     J
> 
> The following changes since commit 79b520e87e1214cfa107bdc8528b5d6c055a8b82:
>   Linus Torvalds (1):
>         Merge branch 'for-linus' of git://oss.sgi.com/xfs/xfs
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git bugfix
> 
> Jeremy Fitzhardinge (2):
>       xen: check EFER for NX before setting up GDT mapping
>       x86: split NX setup into separate file to limit unstack-protected code
> 
>  arch/x86/include/asm/pgtable_types.h |    1 +
>  arch/x86/mm/Makefile                 |    3 +-
>  arch/x86/mm/init.c                   |   63 -------------------------------
>  arch/x86/mm/setup_nx.c               |   69 ++++++++++++++++++++++++++++++++++
>  arch/x86/xen/enlighten.c             |   10 ++--
>  5 files changed, 77 insertions(+), 69 deletions(-)
>  create mode 100644 arch/x86/mm/setup_nx.c

Pulled, thanks Jeremy!

	Ingo
