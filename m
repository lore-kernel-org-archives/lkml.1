Return-Path: <linux-kernel-owner+w=401wt.eu-S1757890AbXE1FXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890AbXE1FXM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 01:23:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbXE1FW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 01:22:59 -0400
Received: from terminus.zytor.com ([192.83.249.54]:53227 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131AbXE1FW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 01:22:59 -0400
Message-ID: <465A6719.4040807@zytor.com>
Date: Sun, 27 May 2007 22:22:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: David Miller <davem@davemloft.net>, abraham.manu@gmail.com, greg@kroah.com,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: PCIE
References: <46561287.8020103@gmail.com> <ada1wh560u1.fsf@cisco.com>	<46584C30.4030206@gmail.com>	<20070526.154910.78725926.davem@davemloft.net> <ada3b1h3gke.fsf@cisco.com>
In-Reply-To: <ada3b1h3gke.fsf@cisco.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> 
> I have a hard time imagining a PCI host bus controller that converts
> MSI interrupts back to wire interrupts that go to pins on the CPU.
> For one thing it would be hard to maintain the guarantee that
> MSI interrupts can't pass DMAs.  And it would be an absolutely silly
> architecture too.
> 

Well, on pretty much all CPUs interrupts sooner or later are combined to
an interrupt signal (not necessarily an external pin) on the CPU
indicating that an interrupt has happened.  On many CPUs demultiplex is
then done in software.

As I said, I have seen at least one architecture where MSIs are treated
as nothing other than another PCI interrupt -- you get five status bits
from the PCI unit -- INTA, INTB, INTC, INTD, MSI.  Needless to say, I
didn't bother enabling MSI on that platform.  Even if it had worked
correctly, which I kind of doubt, it would probably have been a net loss.

	-hpa
