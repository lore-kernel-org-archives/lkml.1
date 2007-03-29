Return-Path: <linux-kernel-owner+w=401wt.eu-S1030468AbXC2Q7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030468AbXC2Q7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 12:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030453AbXC2Q7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 12:59:39 -0400
Received: from smtp.osdl.org ([65.172.181.24]:60985 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030417AbXC2Q7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 12:59:38 -0400
Date: Thu, 29 Mar 2007 09:53:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
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
Subject: Re: [PATCH v2] Add suspend/resume for HPET
In-Reply-To: <200703291546.48996.maximlevitsky@gmail.com>
Message-ID: <Pine.LNX.4.64.0703290949060.6730@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
 <460BBD1B.4040308@ru.mvista.com> <200703291531.18253.maximlevitsky@gmail.com>
 <200703291546.48996.maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 29 Mar 2007, Maxim Levitsky wrote:
>
> Subject: Add suspend/resume for HPET
>
> This adds support of suspend/resume on i386 for HPET
>
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> 
> ---
>  arch/i386/kernel/hpet.c |   68 +++++++++++++++++++++++++++++++++++++++++++++++

Btw, what about arch/x86_64/kernel/hpet.c?

That thing seems totally broken. Lookie here:

  arch/x86_64/kernel/hpet.c:irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id, struct pt_regs *regs)
  drivers/char/rtc.c:extern irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id);

anybody see a problem? The x86-64 version doesn't seem to be very well 
maintained. Is there some fundamental reason why this file isn't shared 
across architectures?

			Linus
