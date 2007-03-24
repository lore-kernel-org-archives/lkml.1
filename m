Return-Path: <linux-kernel-owner+w=401wt.eu-S932702AbXCXTMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932702AbXCXTMb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 15:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932403AbXCXTMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 15:12:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59965 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932702AbXCXTMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 15:12:30 -0400
Date: Sat, 24 Mar 2007 20:11:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: tglx@linutronix.de, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] x86_64: avoid sending LOCAL_TIMER_VECTOR IPI to itself
Message-ID: <20070324191112.GA1626@elte.hu>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <20070323184828.GP752@stusta.de> <46046D6D.3030202@madrabbit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46046D6D.3030202@madrabbit.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ray Lee <ray-lk@madrabbit.org> wrote:

> Subject: [PATCH] x86_64: avoid sending LOCAL_TIMER_VECTOR IPI to 
> itself
> 
> Ray Lee reported, that on an UP kernel with "noapic" command line 
> option set, the box locks hard during boot.

i think this bug deserves a bit more attention, because similar problems 
could be in other codepaths too.

the problem here is that we tried to send an IPI to ourselves - which 
confused Ray's system which has an IO-APIC, but where due to noapic we 
keep the IO-APIC in its BIOS default.

this isnt a new problem: the new time code just exposed it more 
prominently that it was visible before. (the SMP kernel probably would 
hang in a similar way on Ray's system)

i dont see any clear debugging in the IPI code that excludes self-IPIs. 
I think the only valid way to do that is to use DEST_SELF. Andi?

	Ingo
