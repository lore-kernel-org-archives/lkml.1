Return-Path: <linux-kernel-owner+w=401wt.eu-S1422704AbXCNWe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422704AbXCNWe0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 18:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422688AbXCNWeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 18:34:25 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:44873 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422704AbXCNWeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 18:34:24 -0400
Message-ID: <45F87863.9040408@garzik.org>
Date: Wed, 14 Mar 2007 18:34:11 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: rmk+lkml@arm.linux.org.uk
CC: Tejun Heo <htejun@gmail.com>, gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, michal.k.k.piotrowski@gmail.com,
       linux-ide@vger.kernel.org, tglx@linutronix.de,
       shemminger@linux-foundation.org, mlord@pobox.com,
       linux-pm@lists.osdl.org
Subject: Re: [PATCH/RFC] PCI prepare/activate instead of enable to avoid IRQ
 storm and rogue DMA access
References: <20070314152302.GB15600@htj.dyndns.org> <20070314215605.GA7194@flint.arm.linux.org.uk>
In-Reply-To: <20070314215605.GA7194@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:
> pci_enable_device() doesn't deal with this; in most PCI setups I've
> seen, there is no control at PCI level over whether a device generates
> an interrupt on the bus.  Certainly the memory and io command enables

PCI grew an interrupt enable while you weren't looking: 
PCI_COMMAND_INTX_DISABLE

No idea about ARM, but almost all PCI devices made in the past few years 
support that bit.

Unless you are using a PCI Express device (maybe PCI-X too?), though, 
you cannot count on the bit's presence.  It was added in PCI 2.3 I 
think.  Older PCI devices certainly do not have this standardized bit.

	Jeff


