Return-Path: <linux-kernel-owner+w=401wt.eu-S1754090AbXLDNC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbXLDNC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 08:02:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbXLDNCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 08:02:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37116 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313AbXLDNCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 08:02:51 -0500
Date: Tue, 4 Dec 2007 14:02:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Shi Weihua <shiwh@cn.fujitsu.com>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/3] signal(i386): alternative signal stack wraparound
	occurs
Message-ID: <20071204130218.GE31590@elte.hu>
References: <474CF7D5.6010702@cn.fujitsu.com> <474D05AE.60905@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474D05AE.60905@cn.fujitsu.com>
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


* Shi Weihua <shiwh@cn.fujitsu.com> wrote:

> > When it's the handler function itself or its callees that cause the 
> > overflow, rather than the signal handler frame setup alone crossing 
> > the boundary, this still won't help.  But I don't see any way to 
> > distinguish that from the valid longjmp case.
> 
> Thank you for your detailed explanation and patch. I tested your 
> patch, unfortunately it can not stop all kinds of overflow.
[...]
> So, the patch I posted is still needed 

thanks, i've picked up your fix for x86.git, for 2.6.25 merging.

> Surely, adding a variable to sched.h is not a good idea. 
> Could you tell me a better place to store the previous esp?

i think sched.h is ok - it has a sas_ss_sp field already. Alternatively, 
if we only want this in x86, we could put it into the thread_struct - 
but i think eventually other architectures would want to use this too, 
right?

	Ingo
