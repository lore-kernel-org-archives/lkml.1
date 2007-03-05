Return-Path: <linux-kernel-owner+w=401wt.eu-S1752776AbXCEMtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776AbXCEMtY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 07:49:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932344AbXCEMtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 07:49:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45785 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773AbXCEMtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 07:49:23 -0500
Date: Mon, 5 Mar 2007 13:40:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@qumranet.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       Andi Kleen <ak@suse.de>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch] paravirt: VDSO page is essential
Message-ID: <20070305124024.GA19338@elte.hu>
References: <20070305120631.GA14105@elte.hu> <45EC0EB7.7080300@qumranet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45EC0EB7.7080300@qumranet.com>
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


* Avi Kivity <avi@qumranet.com> wrote:

> >-#ifdef CONFIG_PARAVIRT
> >-unsigned int __read_mostly vdso_enabled = 0;
> >-#else
> > unsigned int __read_mostly vdso_enabled = 1;
> >-#endif

> Can't paravirt patch the syscall instruction like it does the rest of 
> the kernel?

we want to keep the guest as simple and unmodified as possible. And all 
this #ifdef jungle /will/ bite back. Especially if the change goes in 
with zero explanation like it did:

    [PATCH] paravirt: Disable vdso by default when CONFIG_PARAVIRT is enabled

    They don't work together and this way even glibc still works.

i rather want an experimental feature (CONFIG_PARAVIRT) broken on some 
hypervisors for a bit than an entire body of guest OSs getting used to 
the "you dont have to deal with this VDSO annoyance by default" quirk 
forever ...

but yes, i agree that the hypervisor should have the ability to patch 
the syscall instruction of both the hypervisor interface and of the VDSO 
interface. But this wasnt implemented like that, and the #ifdef quirk 
just /prevents/ a sane solution like that from ever getting done the 
right way.

	Ingo
