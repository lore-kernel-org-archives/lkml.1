Return-Path: <linux-kernel-owner+w=401wt.eu-S1030524AbXC2R27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030524AbXC2R27 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 13:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030565AbXC2R26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 13:28:58 -0400
Received: from hu-out-0506.google.com ([72.14.214.230]:48481 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030524AbXC2R24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 13:28:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=kww1twPe1gYP33MOsIGN4mn9D6HGFg+wEDkApbO0Xw7LoAEM/QmSPhABk0mgfyb0atcTjgHK4rYP5oY3FlWC10Uv1QsJNkZPvdPMMrnynJi5IeV9o51AuY/moNsE2lKGoXvZNkLpS15ZytKA+ogihkk1RfEa8v2nATa6yc+wsIE=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2] Add suspend/resume for HPET
Date: Thu, 29 Mar 2007 19:28:41 +0200
User-Agent: KMail/1.9.6
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, Ingo Molnar <mingo@elte.hu>,
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
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <200703291546.48996.maximlevitsky@gmail.com> <Pine.LNX.4.64.0703290949060.6730@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703290949060.6730@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703291928.42122.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 March 2007 18:53:37 Linus Torvalds wrote:
> 
> On Thu, 29 Mar 2007, Maxim Levitsky wrote:
> >
> > Subject: Add suspend/resume for HPET
> >
> > This adds support of suspend/resume on i386 for HPET
> >
> > Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> > 
> > ---
> >  arch/i386/kernel/hpet.c |   68 +++++++++++++++++++++++++++++++++++++++++++++++
> 
> Btw, what about arch/x86_64/kernel/hpet.c?
> 
> That thing seems totally broken. Lookie here:
> 
>   arch/x86_64/kernel/hpet.c:irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id, struct pt_regs *regs)
>   drivers/char/rtc.c:extern irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id);
> 
> anybody see a problem? The x86-64 version doesn't seem to be very well 
> maintained. Is there some fundamental reason why this file isn't shared 
> across architectures?
> 
> 			Linus
> 

Hi,
	I agree with that, there seems to be lot of code duplication between i386 and x86_64.
	By the way, x86_64 does take care of suspend/resume for hpet, it is done by 

	linux-2.6/arch/x86_64/kernel/time.c:timer_resume(struct sys_device *dev):
		hpet_reenable()


	on i386 PIT driver goes out of way when HPET is detected
	So it seems that there is lot of work to do to remove redundant code.


	Best regards,
		Maxim Levitsky
