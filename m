Return-Path: <linux-kernel-owner+w=401wt.eu-S1758881AbXL3WCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758881AbXL3WCc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 17:02:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758070AbXL3WCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 17:02:16 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33416 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758048AbXL3WCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 17:02:14 -0500
Date: Sun, 30 Dec 2007 22:57:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH] Hibernation: Document __save_processor_state() on
	x86-64
Message-ID: <20071230215745.GB31386@elte.hu>
References: <200712281353.37976.rjw@sisk.pl> <200712302248.03567.rjw@sisk.pl> <20071230213126.GB14654@elte.hu> <200712302308.51562.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712302308.51562.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> > what's exactly in the hibernation image? Dirty data i suppose
> 
> No, everything, including the kernel code, page tables etc. :-)
> 
> > - but what about kernel-internal pages. What if we go from SLAB to 
> > SLUB? What if the size of a structure changes? Etc.
> 
> We can go from SLAB to SLUB just fine, it doesn't matter.  The only 
> thing that matters is we have to jump to the right address at the end 
> of core_restore_code() (defined in arch/x86/kernel/suspend_asm_64.S).

ok, just to make sure we are talking about the same thing. Do you mean 
we can restore an image saved by v2.6.12 into v2.6.24? I.e. a 2.6.24 
kernel will be able to run a 2.6.12 kernel's hibernation image, with all 
the kernel internal data from v2.6.12, etc? No way can that work.

	Ingo
