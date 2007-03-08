Return-Path: <linux-kernel-owner+w=401wt.eu-S1751455AbXCHICp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455AbXCHICp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 03:02:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbXCHICp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 03:02:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54025 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455AbXCHICn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 03:02:43 -0500
Date: Thu, 8 Mar 2007 09:01:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: tglx@linutronix.de, Dan Hecht <dhecht@vmware.com>,
       Zachary Amsden <zach@vmware.com>, akpm@linux-foundation.org, ak@suse.de,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
Message-ID: <20070308080131.GB9295@elte.hu>
References: <45EE0628.1080108@goop.org> <45EE08E8.2020008@vmware.com> <1173228544.24738.514.camel@localhost.localdomain> <45EE0D10.7070807@vmware.com> <1173230305.24738.529.camel@localhost.localdomain> <45EE1EA3.90803@vmware.com> <1173256666.24738.576.camel@localhost.localdomain> <45EEF966.6060902@goop.org> <1173300032.24738.750.camel@localhost.localdomain> <45EF2991.1020204@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45EF2991.1020204@goop.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> > Your implementation is almost the perfect prototype, if you move the 
> > 128 bit hackery into the hypervisor and hide it away from the kernel 
> > :)
> 
> The point is to use the tsc to avoid making any hypercalls, so dealing 
> with the tsc->ns conversion has to happen on the guest side somehow.

you are obsessed with avoiding a hypercall, but why? Granted it's slow 
especially on things like SVN/VMX, but it's not fundamentally slow. We 
definitely do not want to design our whole APIs and abstractions around 
the temporary notion that 'hypercalls are slow'. I'd expect hypercalls 
to be put into silicon just as much as SYSENTER was put into silicon. 
Anyway, in terms of guest time code, a /big/ amount of design junk can 
be avoided by not trying to do sillynesses like 'virtual time'. The TSC 
is awfully unreliable.

really, it's a bit as if Linus looked at his 386DX CPU when he bought it 
16 years ago and decided that: "this CPU executes 16-bit code much 
faster than 32-bit code, so lets base this new toy OS on 16-bit code. 
Sure, it's a bit of a pain to use, compared to 32-bit code, but users 
demand performance!".

/THIS/ is the kind of junk we are trying to protect Linux against. 
Basically hypervisors are a way to prolong hardware legacies, and 
because unlike real hardware software ABIs dont actually burn out with 
time, and people are stubborn about using them, their effects are alot 
worse and alot longer than that of legacy hardware.

	Ingo
