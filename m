Return-Path: <linux-kernel-owner+w=401wt.eu-S1753796AbXCaR7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbXCaR7N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 13:59:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753791AbXCaR7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 13:59:13 -0400
Received: from homer.mvista.com ([63.81.120.158]:55502 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753778AbXCaR7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 13:59:12 -0400
Subject: Re: [PATCH v2] Add suspend/resume for HPET
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, tglx@linutronix.de,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
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
In-Reply-To: <20070331171740.GA11750@elte.hu>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <200703291546.48996.maximlevitsky@gmail.com>
	 <1175356272.28263.27.camel@localhost.localdomain>
	 <200703311956.35922.maximlevitsky@gmail.com>
	 <Pine.LNX.4.64.0703311004310.6730@woody.linux-foundation.org>
	 <20070331171740.GA11750@elte.hu>
Content-Type: text/plain
Date: Sat, 31 Mar 2007 10:58:29 -0700
Message-Id: <1175363910.12252.196.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-03-31 at 19:17 +0200, Ingo Molnar wrote:

> yeah. There's some practical problems that need to be sorted out: much 
> of the current GTOD code is irq-driven (and all GTOD locks are 
> irq-safe), while the sysfs code needs to run in process-context level. 
> 
> Clocksources 'arrive' and 'depart' in hardirq context (which is the 
> primary place where we notice their breakage, determine that they are 
> now verified to be usable, etc.). This came partly from legacy: the 
> gradual conversion of the monolithic time code, and the need to preserve 
> GTOD and non-GTOD architectures without too much duplication. It also 
> came partly because there's also a fundamental need to have accurate 
> time, which is better served from irq context.
> 

Is this in reference to the irq-context clocksource polling stuff? I
don't see a dire reason to keep that code, and I agree removing that is
a certainly a worth while cleanup .. I added this cleanup to one of my
trees when you first suggested it , and there is some infrastructure
that really should be added to facilitate it.

Daniel

