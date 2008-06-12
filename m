Return-Path: <linux-kernel-owner+w=401wt.eu-S1753666AbYFLE1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbYFLE1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 00:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750813AbYFLE1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 00:27:01 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:21635 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbYFLE1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 00:27:00 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Malte Cornils <malte@cornils.net>
Subject: Re: Lenovo ThinkCentre A55: parport_pc 00:0a: disabled;  probe of 00:0a failed with error -22
Date: Wed, 11 Jun 2008 22:26:44 -0600
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <1213221122.20453.26.camel@localhost>
In-Reply-To: <1213221122.20453.26.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806112226.44596.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 June 2008 3:52:01 pm Malte Cornils wrote:
> a friend of mine is unable to print on her system. I could trace that to
> the kernel not finding the parallel port on the system. Windows Vista,
> for whatever that's worth, prints fine.
>
> dmesg says:
> [   40.935843] parport_pc 00:0a: disabled
> [   40.935850] parport_pc: probe of 00:0a failed with error -22
>
> rmmod parport_pc ; modprobe parport_pc io=0x378 irq=none
> did not work either, the detection failed and echoing some bytes to
> the /dev/lp0 device fails, too.
>
> Booting with noapic or pci=routeirq did not help, booting with noacpi
> nolapic generated in the system grinding to a halt, which made getting
> information out of it difficult due to the remote telephone debugging.

There are some known PNPACPI problems that affect parport_pc.
You could try booting with "pnpacpi=off", which should cause
us to use PNPBIOS instead.

It would be very useful if you could build a current -mm tree
with CONFIG_PNP_DEBUG turned on and collect the dmesg log.  That
tree has the known PNPACPI problems fixed, so it *might* fix the
problem you're seeing.  And if not, the debug output might have
more clues.

Bjorn

