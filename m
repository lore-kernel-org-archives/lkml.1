Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbYGIT1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbYGIT1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 15:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750940AbYGIT07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 15:26:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44158 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbYGIT06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 15:26:58 -0400
Date: Wed, 9 Jul 2008 21:26:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, LKML <linux-kernel@vger.kernel.org>,
       Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@linux-foundation.org>,
       Petr Tesarik <ptesarik@suse.cz>,
       Virtualization <virtualization@lists.linux-foundation.org>,
       Xen devel <xen-devel@lists.xensource.com>,
       Thomas Friebel <thomas.friebel@amd.com>, Avi Kivity <avi@qumranet.com>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [patch] x86, paravirt-spinlocks: fix boot hang
Message-ID: <20080709192630.GA4804@elte.hu>
References: <20080707190749.299430659@goop.org> <20080709122852.GA30579@elte.hu> <20080709133358.GA7005@elte.hu> <20080709134944.GA15190@elte.hu> <4874DF7F.4080204@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4874DF7F.4080204@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

>> should never
>>     be built with -pg (which ftrace does). Marking paravirt.o as 
>>     non-pg and marking all spinlock ops as always-inline solve the 
>>     hang.
>>    
>
> Thanks Ingo, that would have taken me a while to work out.

yeah, i figured i'd be the better candidate to debug ftrace related 
problems ;-)

> Presumably that means that xen/smp.o should also be built without -pg.  
> In fact, should I move the spinlock code into its own file, so that 
> ftrace can cover as much as it can?

hm, yeah. Anything that can be called via the lowest level spinlock 
functions should be either notrace, or, better, in a -pg-excluded .o 
file. Putting it all into a separate file would cover it nicely i think.

	Ingo
