Return-Path: <linux-kernel-owner+w=401wt.eu-S1752336AbXC1Qoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336AbXC1Qoq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 12:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbXC1Qoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 12:44:46 -0400
Received: from smtp.osdl.org ([65.172.181.24]:49820 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbXC1Qop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 12:44:45 -0400
Date: Wed, 28 Mar 2007 09:38:48 -0700 (PDT)
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
Subject: Re: [3/6] 2.6.21-rc4: known regressions
In-Reply-To: <200703281701.23876.maximlevitsky@gmail.com>
Message-ID: <Pine.LNX.4.64.0703280931520.6730@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
 <200703281543.47049.maximlevitsky@gmail.com> <20070328144148.GA16244@elte.hu>
 <200703281701.23876.maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 28 Mar 2007, Maxim wrote:
> 
> 	Now I don't have a clue how to set those bits if only HPET is used as clock source because now clocksources
> 	don't have _any_ resume hook.

One thing that drives me wild about that "clocksource resume" thing is 
that it seems to think that clocksources are somehow different from any 
other system devices..

Why isn't the HPET considered a "device", and has it's own *device* 
"suspend" and "resume"? Why do we seem to think that only "set_mode()" 
etc should wake up clock sources?

It's a *device*, dammit. It should save and resume like one (probably as a 
system device). The "set_mode()" etc stuff is at a completely different 
(higher) conceptual level.

Thomas? It does seem like Maxim has hit the nail on the head (at least 
partly) on the HPET timer resume problems..

		Linus
