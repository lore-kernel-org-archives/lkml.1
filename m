Return-Path: <linux-kernel-owner+w=401wt.eu-S1753654AbXCaROk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654AbXCaROk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 13:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbXCaROk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 13:14:40 -0400
Received: from smtp.osdl.org ([65.172.181.24]:57139 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557AbXCaROj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 13:14:39 -0400
Date: Sat, 31 Mar 2007 10:09:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
cc: tglx@linutronix.de, Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ingo Molnar <mingo@elte.hu>, Jeff Chua <jeff.chua.linux@gmail.com>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz,
       linux-pm@lists.osdl.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz, Jens Axboe <jens.axboe@oracle.com>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       jgarzik@pobox.com, linux-ide@vger.kernel.org,
       "Michael S. Tsirkin" <mst@mellanox.co.il>
Subject: Re: [PATCH v2] Add suspend/resume for HPET
In-Reply-To: <200703311956.35922.maximlevitsky@gmail.com>
Message-ID: <Pine.LNX.4.64.0703311004310.6730@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
 <200703291546.48996.maximlevitsky@gmail.com> <1175356272.28263.27.camel@localhost.localdomain>
 <200703311956.35922.maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 31 Mar 2007, Maxim Levitsky wrote:
> 
> So maybe I was right afrer all,
> Maybe it is better to add a suspend/resume hook to each clock source and call 
> it from timekeeping_resume() ?

Umm.. WHy not make the device tree look like this:

	    -- "clocksource" -- +-- HPET
				|
				+-- TSC
				|
				+-- i8259
				|
				+-- lapic timer
				|
				.. whatever else

and use the "struct device" that we *have* for this? The whole "struct 
device" is literally designed to do this, and to be embedded into whatever 
bigger structures you have that describes higher-level behaviour. Ie you'd 
put a "struct device" inside the "struct clocksource".

That thingalready *has* the suspend/resume hooks, and it will mean that 
people will see the clocks in the device tree rather than have a new 
notion.


			Linus
