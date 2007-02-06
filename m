Return-Path: <linux-kernel-owner+w=401wt.eu-S965577AbXBFWR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965577AbXBFWR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 17:17:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965541AbXBFWR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 17:17:57 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:49658 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965577AbXBFWRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 17:17:55 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       "Lu, Yinghai" <yinghai.lu@amd.com>,
       Luigi Genoni <luigi.genoni@pirelli.com>,
       Natalie Protasevich <protasnb@gmail.com>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 2/2] x86_64 irq:  Handle irqs pending in IRR during irq migration.
References: <200701221116.13154.luigi.genoni@pirelli.com>
	<200702021848.55921.luigi.genoni@pirelli.com>
	<m1ejp85tgm.fsf@ebiederm.dsl.xmission.com>
	<200702021905.39922.luigi.genoni@pirelli.com>
	<m1zm7w3wvr.fsf_-_@ebiederm.dsl.xmission.com>
	<m1veik3woc.fsf_-_@ebiederm.dsl.xmission.com>
	<20070206073616.GA15016@elte.hu>
Date: Tue, 06 Feb 2007 15:16:53 -0700
In-Reply-To: <20070206073616.GA15016@elte.hu> (Ingo Molnar's message of "Tue,
	6 Feb 2007 08:36:16 +0100")
Message-ID: <m1odo7q6cq.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo would it be reasonable to get a wait queue so I can wait for an
irq that needs the delayed disable action to actually become masked?

There are a lot of practical reasons while I cannot reprogram an
unmasked irq.  However if we can wait it should be able to get all of
the convoluted irq migration logic out of interrupt context, and into
process context.

If know interrupts have been enabled on the cpus where an irq could be
delivered after the irq has been masked, I know that the irq is not
currently in progress. 

Therefore I know the irq will not be in progress again until the irq
is unmasked.

Once I know the irq will not be received again it is safe to modify
the irq handling data structures and the interrupt controller.

I think the only generic piece missing from this equation is a wait
queue so I can wait for the irq to become masked.  Say a generic
sleeping masq_irq() call?

Eric
