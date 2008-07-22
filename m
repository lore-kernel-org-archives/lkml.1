Return-Path: <linux-kernel-owner+w=401wt.eu-S1754099AbYGVN4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbYGVN4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 09:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbYGVN4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 09:56:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbYGVN4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 09:56:37 -0400
Date: Tue, 22 Jul 2008 15:56:29 +0200
From: Michal Schmidt <mschmidt@redhat.com>
To: David Vrabel <david.vrabel@csr.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: PCI: MSI interrupts masked using prohibited method
Message-ID: <20080722155629.1160635e@brian.englab.brq.redhat.com>
In-Reply-To: <48807166.9010006@csr.com>
References: <4860D09D.4060801@csr.com>
	<4864DA54.6000205@csr.com>
	<200806271007.26248.jbarnes@virtuousgeek.org>
	<200807161243.03360.jbarnes@virtuousgeek.org>
	<20080716195853.GL25255@parisc-linux.org>
	<487F45C0.2080201@csr.com>
	<20080717153917.GR25255@parisc-linux.org>
	<alpine.LFD.1.10.0807171745270.4316@apollo.tec.linutronix.de>
	<20080717165630.GT25255@parisc-linux.org>
	<487F7DFA.10101@csr.com>
	<20080717194846.GU25255@parisc-linux.org>
	<48807166.9010006@csr.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2008 11:33:10 +0100
David Vrabel <david.vrabel@csr.com> wrote:

> Matthew Wilcox wrote:
> > 
> > I think David's original patch (just declining to mask the
> > interrupt) is the best approach to take.  Perhaps architectures
> > with saner interrupt hardware would like to try the approach I've
> > mentioned here.
> > 
> > I don't like the comment in http://lkml.org/lkml/2008/6/27/199 as
> > it's not prohibited ... just a bad idea.  How about this patch?
> 
> The PCI specification is quite clear that it's prohibited.  The
> problem also is more severe than simply having spurious interrupts --
> with some devices if a line interrupt is generated (regardless of
> whether it ends up on the bus) then no more interrupts are generated.
> 
> I also think that the change requires a comment in the code.  It odd
> to have a mask function that doesn't really mask so a comment is
> necessary to explain why this is.
> 
> Please apply this instead.
> 
> David

This breaks the setting of SMP affinity for MSI interrupts :-(
With the patch, writes to /proc/irq/<n>/smp_affinity are ignored for an
MSI interrupt.

Michal
