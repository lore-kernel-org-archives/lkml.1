Return-Path: <linux-kernel-owner+w=401wt.eu-S934005AbYEFVdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934005AbYEFVdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 17:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933686AbYEFV1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 17:27:25 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:29104 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933566AbYEFV1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 17:27:21 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [PATCH 3/3] PNP: add AD1815 and AD1816 quirks
Date: Tue, 6 May 2008 15:27:20 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Uwe Bugla <uwe.bugla@gmx.de>, Takashi Iwai <tiwai@suse.de>,
       Len Brown <len.brown@intel.com>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <481FAC37.6090703@keyaccess.nl> <200805061308.14673.bjorn.helgaas@hp.com> <4820C846.2040205@keyaccess.nl>
In-Reply-To: <4820C846.2040205@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805061527.21134.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 May 2008 03:06:14 pm Rene Herman wrote:
> ...
> > I'm vaguely uncomfortable because this quirk isn't really working
> > around a hardware/firmware issue; it's stepping around the fact
> > that Linux doesn't know how to allocate IRQs between ISA and PCI.
> > Does anybody know how Windows handles this?  If Windows can do it
> > without user intervention, maybe we can too.
> 
> Yes, I can appreciate the vague uncomfort. This is improving the hardware 
> more then it is fixing it and that might feel like a bit of a misuse of 
> quirks. However, given Linux's ability to operate the MPU401 fully without 
> an assigned IRQ I feel it does make sense. The hardware shouldn't become 
> unavailable just because the system can't find a free IRQ for it.

OK, thanks a lot for the explanation.  It makes a lot more sense
now, and I'm happy with your approach now.  It shouldn't make anything
worse, and it should make the card useful in some cases where it
wasn't before.

> However, with respect to your direct worry I get sort of foggy. All my ISA 
> capable systems seem to have a BIOS that assigns IRQs to each PCI card that 
> I put in as evidenced by the neat list of them that most of them print out 
> just before the screen says "Verifying DMI Pool Data" and loading linux, an 
> OS which I don't recall having ever seen deviate from the BIOS assigned 
> values either.
> 
> That is, I'm not sure in how far Linux is involved at all :-?

This part is just my general unhappiness about options like
"acpi_irq_nobalance" and "acpi_irq_isa=".  I was just wondering
what Windows does when it can't assign PNP IRQs.  Does it assign
them all before PCI, so they know they have enough?  Do it
dynamically move PCI interrupts?  Do it require explicit boot
flags like Linux does?  Or maybe nobody even needs those flags
on Linux, and the flags are effectively unused.

Bjorn
