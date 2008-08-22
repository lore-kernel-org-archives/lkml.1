Return-Path: <linux-kernel-owner+w=401wt.eu-S1753885AbYHVE0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbYHVE0s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 00:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbYHVE0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 00:26:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40786 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbYHVE0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 00:26:38 -0400
Date: Fri, 22 Aug 2008 06:26:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alex Nixon <alex.nixon@citrix.com>, Alan Mayer <ajm@sgi.com>
Subject: Re: [PATCH] x86: fix probe_nr_irqs for xen
Message-ID: <20080822042610.GA15212@elte.hu>
References: <1219349409-15698-1-git-send-email-yhlu.kernel@gmail.com> <48ADFB33.8010204@goop.org> <86802c440808211649h37ac7533q4b95a83306ecd430@mail.gmail.com> <48ADFFD2.7030309@goop.org> <86802c440808211656o20f9a22dv34e3ac8e8e84b4e1@mail.gmail.com> <48AE022F.6030100@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AE022F.6030100@goop.org>
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

> > hope we can kill nr_irqs/NR_IRQS
> 
> When irqs are truely dynamically allocated?

they in essence already are truly dynamic in tip/master. Not yet 
unconditionally so on x86, we chose to also have a !SPARSEIRQ build 
model to make sure dense IRQ arrays still work fine as well. (that's far 
easier to test and validate than to keep a farm of cross compilers to 
other arches alive.)

But by all means SPARSEIRQ is the primary and only model on x86.

We could even plug in the dynamic vector allocator from Alan Mayer now, 
both on 32-bit and on 64-bit x86: Yinghai, any complications expected 
there? I guess we need to unify the local APIC code first.

	Ingo
