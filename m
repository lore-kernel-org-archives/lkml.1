Return-Path: <linux-kernel-owner+w=401wt.eu-S1761403AbXKULhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761403AbXKULhV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 06:37:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755888AbXKULhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 06:37:10 -0500
Received: from madara.hpl.hp.com ([192.6.19.124]:49283 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755453AbXKULhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 06:37:08 -0500
Date: Wed, 21 Nov 2007 03:37:03 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: linux-kernel@vger.kernel.org
Cc: Stephane Eranian <eranian@hpl.hp.com>
Subject: Re: [patch][v2] x86, ptrace: support for branch trace store(BTS)
Message-ID: <20071121113703.GD30184@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> >and it seems like this patch and perfmon2 are going to have to 
> >live with 
> >each other... since they both require the use of the DS save area...
> 
> Hmmm, this might require some synchronization between those two.
> 
> Do you know how (accesses to) MSR's are managed by the kernel?

There is a simple MSR allocator in the nmi watchdog code. It is very
simple though and was only intended for performance counters originally
so you might need to enhance it first for complicated things.

I agree it needs to be extended to manage other not necessarily contiguous
MSR registers.

As for BTS, I am happy to see this resource exposed for debugging purposes.

Note that it could also be used for performance monitoring purposes and it
could be exploited by the perfmon2 subsystem via a new sampling format. This
way one could for instance figure out the path that led to a cache miss. Of
course, this requires that some filtering be applied to BTS which today does
not differentiate loop vs. function branches, AFAIR. The current cost can
be mitigated by using a long sampling period and by monitoring longer.

-- 
-Stephane
