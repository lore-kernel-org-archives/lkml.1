Return-Path: <linux-kernel-owner+w=401wt.eu-S1752929AbXDBHCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbXDBHCW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 03:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbXDBHCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 03:02:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44656 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752929AbXDBHCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 03:02:21 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] enhance initcall_debug, measure latency
References: <20070401181614.GA25648@elte.hu> <20070401182801.GA25956@elte.hu>
From: Andi Kleen <andi@firstfloor.org>
Date: 02 Apr 2007 10:00:59 +0200
In-Reply-To: <20070401182801.GA25956@elte.hu>
Message-ID: <p73vegfyzlw.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> so 93.6% of the allyesconfig bootup time is in 2.5% of the initcalls. If 
> they were fixed then an allyesconfig bzImage, which would be capable to 
> run on every PC known to mankind without any module whatsoever, would 

Assuming that every PC has enough memory @) Allyes is >35MB

> take around 10 seconds to boot up (which is acceptable for kernel bootup 
> time).

It might make sense to measure idle ticks vs busy ticks too.
If it's idle cycles perhaps things can be more easily fixed by multi threading
the initialization. If it's busy cycles perhaps they can be converted
into sleeping cycles.

Perhaps you should tell the individual maintainers for those?
If they still have one. A lot of them look like old hardware
where there might be no working ones left, perhaps just deprecation
would make sense.

> initcall 0xc1f5487d ran for 23083 msecs: pca_isa_init+0x0/0x143()
> initcall 0xc1f54fba ran for 17121 msecs: pcf8574_init+0x0/0x20()

e.g. those just look like bugs.

> initcall 0xc1f0c06f ran for 14710 msecs: net_olddevs_init+0x0/0x169()

That's many drivers initialized together for compatibility ordering reasons.

-Andi

