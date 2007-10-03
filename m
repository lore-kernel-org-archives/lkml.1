Return-Path: <linux-kernel-owner+w=401wt.eu-S1756767AbXJCW0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767AbXJCW0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 18:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbXJCW0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 18:26:11 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:57876 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbXJCW0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 18:26:10 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: benh@kernel.crashing.org
Cc: Loic Prylli <loic@myri.com>, linux-pci@atrey.karlin.mff.cuni.cz,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: MSI problem since 2.6.21 for devices not providing a mask in their MSI capability
References: <470405BB.2000208@myri.com>
	<m14ph7amxq.fsf@ebiederm.dsl.xmission.com>
	<1191448992.22572.110.camel@pasglop>
Date: Wed, 03 Oct 2007 16:25:39 -0600
In-Reply-To: <1191448992.22572.110.camel@pasglop> (Benjamin Herrenschmidt's
	message of "Thu, 04 Oct 2007 08:03:12 +1000")
Message-ID: <m1wsu396os.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:
>
> Well, yes and no ... A valid option here would be to use soft-masking,
> which is possible because MSIs are edge interrupts. That is, basically,
> when masked, just ignore them and set IRQF_PENDING, and when unmasked,
> replay (which can be done with softirq if there is no HW mechanism for
> that). The genirq code contains all the necessary infrastructure for
> doing that stuff, it's fairly trivial, and would probably avoid stepping
> in HW lalaland (how much do you bet HW generally get that masking thing
> wrong ?)

Well.  If people actually use it I suspect it will work ok.  The
circuitry is quite simple so as long as people get their requirements
straight we should be fine.  Which is why I tried to get everything
working as well as we could sooner rather then later.  Of course
drivers are free not to call anything that would cause the irq
to be masked.

That said the current disable_irq and enable_irq path is using the
IRQF_PENDING infrastructure on x86.  So the only time this comes up
is for irq migration.

Eric
