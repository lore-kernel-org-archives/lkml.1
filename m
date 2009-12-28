Return-Path: <linux-kernel-owner+w=401wt.eu-S1751524AbZL1IjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524AbZL1IjN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 03:39:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751168AbZL1IjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 03:39:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39948 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbZL1IjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 03:39:11 -0500
Date: Mon, 28 Dec 2009 09:38:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Naga Chumbalkar <nagananda.chumbalkar@hp.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, oprofile-list@lists.sf.net,
       tglx@linutronix.de
Subject: Re: [PATCH] x86, perfctr: remove unused func
 avail_to_resrv_perfctr_nmi()
Message-ID: <20091228083845.GK28652@elte.hu>
References: <20091224015441.6005.4408.sendpatchset@localhost.localdomain>
 <20091224150458.GA5143@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091224150458.GA5143@lenovo>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> On Thu, Dec 24, 2009 at 01:54:47AM +0000, Naga Chumbalkar wrote:
> > avail_to_resrv_perfctr_nmi() is neither EXPORT'd, nor used in the file.
> > So remove it.
> > 
> > Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
> > ---
> >  arch/x86/include/asm/nmi.h             |    1 -
> >  arch/x86/kernel/cpu/perfctr-watchdog.c |   11 -----------
> >  2 files changed, 0 insertions(+), 12 deletions(-)
> > 
> 
> Hi Naga, this looks good to me! Thanks.
> 
> Is there any plans to use this routine in future
> so we shouldn't touch this snippet?

Not that i know of.

In fact we should transform/migrate the NMI watchdog driver by making it based 
on a kernel-internal created perf event. (which is what the NMI watchdog 
really is: a periodic NMI event occuring once per second and running a 
callback function.)

That would give us NMI watchdog support on all future x86 CPUs, automatically 
- without having to extend the arch/x86/kernel/cpu/perfctr-watchdog.c code for 
it.

	Ingo
