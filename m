Return-Path: <linux-kernel-owner+w=401wt.eu-S1754600AbXKMNxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbXKMNxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 08:53:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbXKMNxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 08:53:23 -0500
Received: from ns.suse.de ([195.135.220.2]:45983 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585AbXKMNxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 08:53:22 -0500
To: "Robert Richter" <robert.richter@amd.com>
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: x86 merge: Keep kernel/cpu for CPU specific code?
From: Andi Kleen <andi@firstfloor.org>
References: <20071113114443.GG18993@erda.amd.com>
Date: Tue, 13 Nov 2007 14:53:20 +0100
In-Reply-To: <20071113114443.GG18993@erda.amd.com> (Robert Richter's message of "Tue\, 13 Nov 2007 12\:44\:43 +0100")
Message-ID: <p73ejeuz1yn.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Robert Richter" <robert.richter@amd.com> writes:

> x86 CPU specific code is currently implemented in different ways for
> 64 and 32 bit. While there are almost no CPU specific files for 64
> bit, there is the arch/x86/kernel/cpu/ directory for 32 bit. Is there
> already an idea about whether to use kernel/cpu also for 64 bit?

Well it's already used as it has been pointed out. 

Regarding the core initialization code:

The 32bit set up here is kind of crappy. Initcalls that are commented
out, weird ordering, unrelated stuff mixed toegether etc. If you
consider "improving" 64bit here then I would suggest to do some major
clean up in the 32bit parts first.

I personally consider the single file cleaner to hack, but then 64bit
is already vastly simpler anyways because it has much less CPUs to support.

If anything it would probably make sense to separate out generic
stuff (like GDT initialization) from CPU specific initialization.
64bit already separates that better too, but it's also not fully complete.

-Andi
