Return-Path: <linux-kernel-owner+w=401wt.eu-S933014AbXA2Wnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014AbXA2Wnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 17:43:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933021AbXA2Wnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 17:43:32 -0500
Received: from smtp.osdl.org ([65.172.181.24]:60085 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933014AbXA2Wnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 17:43:31 -0500
Date: Mon, 29 Jan 2007 14:40:55 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: Linux 2.6.20-rc6 - sky2 resume breakage
Message-ID: <20070129144055.151cfe52@freekitty>
In-Reply-To: <Pine.LNX.4.64.0701291431320.3611@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org>
	<1169931333.17469.125.camel@localhost.localdomain>
	<20070129113159.7ad22e4c@freekitty>
	<1170101430.29240.34.camel@localhost.localdomain>
	<20070129133849.1b523226@freekitty>
	<1170109401.29240.49.camel@localhost.localdomain>
	<Pine.LNX.4.64.0701291431320.3611@woody.linux-foundation.org>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jan 2007 14:37:23 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Mon, 29 Jan 2007, Thomas Gleixner wrote:
> > 
> > Reverting commit 44ade178249fe53d055fd92113eaa271e06acddd, which added
> > this hackery in the first place, makes the device survive
> > suspend/resume.
> 
> I suspect some BIOSes do *not* screw up the MSI thing on resume, and 
> others do.
> 
> I would suggest that the real fix is to not do that kind of hackery at 
> suspend/resume time (because we can't know what the heck the BIOS does), 
> and instead just do one of two cases:
> 
>  - since MSI is known to be broken for the sky2 driver due to firmware 
>    bugs, just disable it by default if CONFIG_PM is enabled. The 
>    advantages of MSI just aren't all that compelling. Possibly add a 
>    command line option to force MSI to be enabled regardless.

MSI works fine for almost all systems (except AMD systems where
MSI is broken for ALL devices).

>    Simple, direct, and should work for everybody.
> 
>  - Just add a command line to disable MSI for people that it breaks for. 
> 
>    I don't actually like this one. It defaults to the unsafe behaviour, 
>    and while that makes sense in a "well, your machine is broken anyway" 
>    kind of way, the thing is, the advantages of MSI just aren't big enough 
>    to warrant defaulting to a known-unsafe thing, even if only a small 
>    percentage of machines are affected.

Module option out already exists.

