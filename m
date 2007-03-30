Return-Path: <linux-kernel-owner+w=401wt.eu-S1752395AbXC3VFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395AbXC3VFq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 17:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbXC3VFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 17:05:46 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:42637 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbXC3VFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 17:05:45 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Williams, Mitch A" <mitch.a.williams@intel.com>
Cc: "Greg KH" <gregkh@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-pci@atrey.karlin.mff.cuni.cz>, <linux-kernel@vger.kernel.org>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>
Subject: Re: [PATCH 2.6.21-rc5] Flush MSI-X table writes (rev 3)
References: <08FE5CC30C9A3F41BF819A502CF7BF6E0100376E@fmsmsx411.amr.corp.intel.com>
Date: Fri, 30 Mar 2007 15:05:07 -0600
In-Reply-To: <08FE5CC30C9A3F41BF819A502CF7BF6E0100376E@fmsmsx411.amr.corp.intel.com>
	(Mitch A. Williams's message of "Fri, 30 Mar 2007 13:49:20 -0700")
Message-ID: <m1y7leh27w.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Williams, Mitch A" <mitch.a.williams@intel.com> writes:

> Agreed, this is a subtle bug, and was a real hairball to track down.
> Even so, I'm surprised that nobody else has dug into this, since it
> should affect anybody running MSI-X.  I originally thought I was seeing
> a hardware bug, which is why I dug more deeply into the issue.
>
> If Eric is seeing bug reports related to "no vector for IRQ" in the
> wild, then I have to change my stance and agree that this should be
> pushed to -stable.  Every one of those messages indicates that we
> hit the race condition.

There is a non MSI-X cause as well with the ioapics that I believe I have
now worked around.  It was a lot harder because ioapics don't obey the
pci ordering rules.  Although the primary culprit was receiving a second
instance of the an irq before we had acknowledged the first instance.

I had just about concluded that there was likely a second cause for
the "no vector for IRQ" message but I had not been able to confirm
that until I saw the first version of this patch.

In general the rule for -stable is that a fix has to go to -linus
first.  It makes it simple to see if the normal QA has been done
on the patch before we push it towards stable.  So this patch needs to
hit 2.6.21 first.

Eric
