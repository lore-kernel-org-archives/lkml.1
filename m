Return-Path: <linux-kernel-owner+w=401wt.eu-S1755629AbYCaNBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629AbYCaNBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 09:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755266AbYCaNBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 09:01:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34616 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754829AbYCaNBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 09:01:22 -0400
Date: Mon, 31 Mar 2008 15:01:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-s390@vger.kernel.org,
       tony.luck@intel.com, linux-ia64@vger.kernel.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86 TS_RESTORE_SIGMASK
Message-ID: <20080331130106.GA15198@elte.hu>
References: <20080329001230.D013726FA1D@magilla.localdomain> <20080329001341.7F93826FA1D@magilla.localdomain> <alpine.LFD.1.00.0803281746480.14670@woody.linux-foundation.org> <20080329022408.0DD4726FA1D@magilla.localdomain> <20080329031413.EA38926FA1D@magilla.localdomain> <20080329031451.D2E1226FA1D@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080329031451.D2E1226FA1D@magilla.localdomain>
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


* Roland McGrath <roland@redhat.com> wrote:

> Replace TIF_RESTORE_SIGMASK with TS_RESTORE_SIGMASK and define our own 
> set_restore_sigmask() function.  This saves the costly SMP-safe 
> set_bit operation, which we do not need for the sigmask flag since 
> TIF_SIGPENDING always has to be set too.
> 
> Signed-off-by: Roland McGrath <roland@redhat.com>
> ---
>  arch/x86/ia32/ia32_signal.c      |    2 +-
>  arch/x86/kernel/signal_32.c      |   19 ++++++++++---------
>  arch/x86/kernel/signal_64.c      |   16 +++++++++-------
>  include/asm-x86/thread_info_32.h |   13 +++++++++++--
>  include/asm-x86/thread_info_64.h |   13 +++++++++++--
>  5 files changed, 42 insertions(+), 21 deletions(-)

the x86 bits look nice - but i guess this all wants to go into 2.6.26 
via -mm (or linux-next), due to its cross-arch nature?

	Ingo
