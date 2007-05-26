Return-Path: <linux-kernel-owner+w=401wt.eu-S1755137AbXEZXza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137AbXEZXza (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 19:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbXEZXzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 19:55:23 -0400
Received: from colo.lackof.org ([198.49.126.79]:48825 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbXEZXzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 19:55:23 -0400
Date: Sat, 26 May 2007 17:55:15 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: David Miller <davem@davemloft.net>
Cc: abraham.manu@gmail.com, rdreier@cisco.com, greg@kroah.com,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: PCIE
Message-ID: <20070526235515.GA31023@colo.lackof.org>
References: <46561287.8020103@gmail.com> <ada1wh560u1.fsf@cisco.com> <46584C30.4030206@gmail.com> <20070526.154910.78725926.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070526.154910.78725926.davem@davemloft.net>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 26, 2007 at 03:49:10PM -0700, David Miller wrote:
> From: Manu Abraham <abraham.manu@gmail.com>
> Date: Sat, 26 May 2007 19:03:12 +0400
> 
> > i presume then i shouldn't be using IRQF_SHARED, if using MSI.
> 
> That's actually a really good question.
> 
> It is likely architecture dependant whether the PCI controller wires
> unique MSI interrupts to shared cpu interrupt lines.

MSI (and MSI-X) vectors are required to be exclusive.
I submitted that change to pci.txt last year:
	http://lkml.org/lkml/2006/12/25/2

and ISTR I've posted that bit of the PCI spec a few years ago.
But it probably was to linux-pci mailing list only.

> I can imagine many systems where the cpu simply doesn't have enough
> interrupt pins to uniquely identify every possible MSI interrupt
> source.

The cpus haven't been using interrupt pins for a long time now.
Anything with a Local-xAPIC is already using transactions to
signal interrupts even if the OS isn't aware of it.

hth,
grant

