Return-Path: <linux-kernel-owner+w=401wt.eu-S965962AbXC2FOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965962AbXC2FOr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 01:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbXC2FOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 01:14:46 -0400
Received: from smtp.osdl.org ([65.172.181.24]:43329 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221AbXC2FOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 01:14:45 -0400
Date: Wed, 28 Mar 2007 22:08:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Maxim <maximlevitsky@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Jeff Chua <jeff.chua.linux@gmail.com>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz,
       linux-pm@lists.osdl.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz, Jens Axboe <jens.axboe@oracle.com>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       jgarzik@pobox.com, linux-ide@vger.kernel.org,
       "Michael S. Tsirkin" <mst@mellanox.co.il>
Subject: Re: [ PATCH] Add suspend/resume for HPET was: Re: [3/6] 2.6.21-rc4:
 known regressions
In-Reply-To: <200703290641.20236.maximlevitsky@gmail.com>
Message-ID: <Pine.LNX.4.64.0703282203550.6730@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
 <200703281701.23876.maximlevitsky@gmail.com>
 <Pine.LNX.4.64.0703280931520.6730@woody.linux-foundation.org>
 <200703290641.20236.maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 29 Mar 2007, Maxim wrote:
>
> 	I am sending here a patch that as was discussed here adds hpet to list of system devices
> 	and adds suspend/resume hooks this way.
> 	I tested it and it works fine.

Ok, it certainly looks better, but it *also* looks like it just assumes 
the HPET is there. Which would work in testing _with_ a HPET, but would 
likely break on hardware without one, no?

Shouldn't there be at least something like a

	if (!is_hpet_capable())
		return 0;

at the top of that init routine? I'd also expect that you'd need to check 
that "hpet_virt_address" is valid or something?

(Or, better yet, shouldn't we set "boot_hpet_disable" when we decide not 
to use the HPET, and set hpet_virt_address to NULL?)

		Linus
