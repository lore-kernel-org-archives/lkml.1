Return-Path: <linux-kernel-owner+w=401wt.eu-S1756840AbYGRKxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbYGRKxZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 06:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754844AbYGRKxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 06:53:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37804 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412AbYGRKxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 06:53:17 -0400
Date: Fri, 18 Jul 2008 12:52:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] x86: APIC: Remove apic_write_around(); use alternatives
Message-ID: <20080718105259.GY6875@elte.hu>
References: <Pine.LNX.4.55.0807161837080.30858@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0807161837080.30858@cliff.in.clinika.pl>
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


* Maciej W. Rozycki <macro@linux-mips.org> wrote:

>  Use alternatives to select the workaround for the 11AP Pentium 
> erratum for the affected steppings on the fly rather than build time.  
> Remove the X86_GOOD_APIC configuration option and replace all the 
> calls to apic_write_around() with plain apic_write(), protecting 
> accesses to the ESR as appropriate due to the 3AP Pentium erratum.  
> Remove apic_read_around() and all its invocations altogether as not 
> needed.  Remove apic_write_atomic() and all its implementing backends.  
> The use of ASM_OUTPUT2() is not strictly needed for input constraints, 
> but I have used it for readability's sake.

wow, impressive patch!

>  I had the feeling no one else was brave enough to do it, so I went 
> ahead and here it is.  Verified by checking the generated assembly and 
> tested with both a 32-bit and a 64-bit configuration, also with the 
> 11AP "feature" forced on and verified with gdb on /proc/kcore to work 
> as expected (as an 11AP machines are quite hard to get hands on these 
> days).  Some script complained about the use of "volatile", but 
> apic_write() needs it for the same reason and is effectively a 
> replacement for writel(), so I have disregarded it.

kudos for pulling this off :-)

applied to tip/x86/apic. This will interact with tip/x86/x2apic but that 
topic is being worked on anyway. The interaction should be trivial.

	Ingo
