Return-Path: <linux-kernel-owner+w=401wt.eu-S964785AbXA3AMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964785AbXA3AMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 19:12:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbXA3AMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 19:12:38 -0500
Received: from smtp.osdl.org ([65.172.181.24]:34645 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094AbXA3AMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 19:12:38 -0500
Date: Mon, 29 Jan 2007 16:12:27 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stephen Hemminger <shemminger@linux-foundation.org>
cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: Linux 2.6.20-rc6 - sky2 resume breakage
In-Reply-To: <20070129154518.40b0b3d3@freekitty>
Message-ID: <Pine.LNX.4.64.0701291609180.3611@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org>
 <1169931333.17469.125.camel@localhost.localdomain> <20070129113159.7ad22e4c@freekitty>
 <1170101430.29240.34.camel@localhost.localdomain> <20070129133849.1b523226@freekitty>
 <1170109401.29240.49.camel@localhost.localdomain>
 <Pine.LNX.4.64.0701291431320.3611@woody.linux-foundation.org>
 <20070129144055.151cfe52@freekitty> <Pine.LNX.4.64.0701291501180.3611@woody.linux-foundation.org>
 <20070129154518.40b0b3d3@freekitty>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 29 Jan 2007, Stephen Hemminger wrote:
> 
> Why do you insist on maintaining the wrong initialization order
> on resume? When I raised the issue, Len brought up that the resume
> order did not match spec, but then there has been slow progress
> in fixing it (it's buried in -mm tree).

It's not getting merged, SINCE IT DOESN'T WORK. It causes all sorts of 
problems, because ACPI requires all kinds of things to be up and running 
in order to actually work, and that in turn breaks all the devices that 
have different ordering constraints.

ACPI is a piece of sh*t. It asks the OS to do impossible things, like 
running it early in the config sequence when it then at the same time 
wants to depend on stuff that are there *late* in the sequence. It's not 
the first time this insane situation has happened, either.

But we'll try to merge the patch that totally switches around the whole 
initialization order hopefully early after 2.6.20. But no way in hell do 
we do it now, and I personally suspect we'll end reverting it when we do 
try it just because it will probably break other things. But we'll see.

In the meantime, sky2 doesn't work with MSI.

		Linus
