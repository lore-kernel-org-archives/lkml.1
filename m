Return-Path: <linux-kernel-owner+w=401wt.eu-S1759881AbXG0SGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759881AbXG0SGW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 14:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753624AbXG0SGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 14:06:15 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59856 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410AbXG0SGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 14:06:14 -0400
Message-ID: <46AA33FF.4070504@garzik.org>
Date: Fri, 27 Jul 2007 14:05:51 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>, Adam Belay <ambx1@neo.rr.com>,
       Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86, serial: always probe for legacy COM ports
References: <200707271158.50028.bjorn.helgaas@hp.com>
In-Reply-To: <200707271158.50028.bjorn.helgaas@hp.com>
Content-Type: multipart/mixed;
 boundary="------------060507040401030406000205"
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060507040401030406000205
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Bjorn Helgaas wrote:
> Andrew, if you drop
>     revert-x86-serial-convert-legacy-com-ports-to-platform-devices.patch
> and apply this, we should have the previous behavior.  I think the
> conversion to platform devices is still worthwhile.  Obviously, I intend
> this as 2.6.23 material.
> 
> 
> Always probe for serial ports at legacy addresses, even if we have PNPBIOS
> or ACPI that should tell us about those ports.
> 
> We have no reports yet of defective firmware that completely omits ports.
> However, Sébastien Dugué <sebastien.dugue@bull.net> reported that the
> NEC Express5800/120Lh with Phoenix BIOS 6.0.5N52, released 7/12/2005,
> reports COM2 first, then COM1 in the ACPI namespace.
> 
> 8250_pnp currently registers devices in namespace order.  On this machine,
> that makes ttyS0=COM2 and ttyS1=COM1, the reverse of what we want.
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

This is still incomplete, as repeatedly stated.  Here is the email, again.

	Jeff




--------------060507040401030406000205
Content-Type: message/rfc822;
 name="Attached Message"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="Attached Message"

Message-ID: <46A68977.50800@garzik.org>
Date: Tue, 24 Jul 2007 19:21:27 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Russell King <rmk@arm.linux.org.uk>
CC: akpm@linux-foundation.org,  mm-commits@vger.kernel.org, 
 ambx1@neo.rr.com,  bjorn.helgaas@hp.com,  lenb@kernel.org, 
 mjg59@srcf.ucam.org,  sebastien.dugue@bull.net
Subject: Re: + revert-x86-serial-convert-legacy-com-ports-to-platform-devices.patch
 added to -mm tree
References: <200707241810.l6OIABWK026108@imap1.linux-foundation.org> <20070724210557.GA22165@flint.arm.linux.org.uk> <46A66C5A.6050305@garzik.org> <20070724213037.GC22165@flint.arm.linux.org.uk> <46A6774F.5050505@garzik.org> <20070724221052.GE22165@flint.arm.linux.org.uk>
In-Reply-To: <20070724221052.GE22165@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Russell King wrote:
> So we shouldn't even try to remove the legacy "legacy port" probing in
> the serial driver like other platforms have done, which this patch minus
> those bits I mentioned actually achieves?

Move [to a new driver / location in tree]?  Sure.  As long as there are 
no probe order issues, module naming issues (I note distinct lack of 
MODULE_ALIAS for example) or other transitions issues.

Remove?  Definitely not.

Even if we apply your suggested solution, updates are still needed:
* fix kernel-parameters.txt

* address transition issues related to module naming.  other transition 
issues?  has anybody even given this any thought?

* no apparent module unload support (regression or just a bug?)

* add docs for x86/x86-64 users (or point to docs in the source). 
Overall this was a highly "stealthy" change over to the new platform 
driver, without much notice at all.  Not optimum, for a popular device 
on Linux's most popular platform.

I have no complaints about platform_device direction, certainly.  But 
this particular commit was incomplete, poorly described, and broke 
decade+ behavior.

	Jeff





--------------060507040401030406000205--
