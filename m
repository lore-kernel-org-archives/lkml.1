Return-Path: <linux-kernel-owner+w=401wt.eu-S1761640AbZATV5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761640AbZATV5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 16:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753597AbZATV50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 16:57:26 -0500
Received: from iabervon.org ([66.92.72.58]:56108 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287AbZATV5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 16:57:24 -0500
Date: Tue, 20 Jan 2009 16:50:41 -0500 (EST)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Mark Lord <liml@rtr.ca>
cc: IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>, Jeff Garzik <jgarzik@pobox.com>,
       linux-pci@vger.kernel.org
Subject: Re: libata, devm_*, and MSI ?
In-Reply-To: <4975F5C1.8090107@rtr.ca>
Message-ID: <alpine.LNX.1.00.0901201626090.19665@iabervon.org>
References: <4975F5C1.8090107@rtr.ca>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jan 2009, Mark Lord wrote:

> Next, there's no mention of a need for invoking pci_intx() in the HOW-TO,
> yet some device drivers call it, and others do not.

Some devices don't work if you call it (don't send any interrupts); others 
don't work if you don't call it (send both types of interrupts); most 
don't care either way. In any case, the core code should deal with it 
based on quirks. I think there isn't any manufacturer who has had both 
kinds of quirk, and the clarified spec says that the INTX bit shouldn't 
matter when MSI is enabled, so manufacturers are slowly converging to 
that.

Initially, the core didn't do anything, and some drivers implemented the 
need-intx-off quirk; eventually this went into the core as the default 
behavior. Then some drivers implemented the need-intx-on quirk. Then some 
common drivers for different hardware turned out to need it both ways, and 
the core got a real quirk for it. But not all of the drivers have dropped 
the local setting stuff.

The right way to go is to do nothing in the driver and use quirks if you 
need it.

	-Daniel
*This .sig left intentionally blank*
