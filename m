Return-Path: <linux-kernel-owner+w=401wt.eu-S1758765AbXIUNCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765AbXIUNCN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 09:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757363AbXIUNBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 09:01:51 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50141 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757305AbXIUNBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 09:01:50 -0400
Date: Fri, 21 Sep 2007 14:01:20 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Guennadi Liakhovetski <gl@dsa-ac.de>
Cc: Mike Rapoport <mike@compulab.co.il>,
       ARM Linux <linux-arm-kernel@lists.arm.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/03] CM-x270: ITE 8152 PCI bridge support
Message-ID: <20070921130119.GB20538@flint.arm.linux.org.uk>
References: <46F29A0A.4000407@compulab.co.il> <Pine.LNX.4.63.0709211240570.9343@pcgl.dsa-ac.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.63.0709211240570.9343@pcgl.dsa-ac.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 12:42:55PM +0200, Guennadi Liakhovetski wrote:
> On Thu, 20 Sep 2007, Mike Rapoport wrote:
> 
> > This patch provides driver for ITE 8152 PCI bridge.
> > 
> > Signed-off-by: Mike Rapoport <mike@compulab.co.il>
> > 
> >  arch/arm/common/Makefile          |    1 +
> >  arch/arm/common/it8152.c          |  387 +++++++++++++++++++++++++++++++++++++
> 
> Shouldn't it go to drivers/pci and define a platform driver? it8152 is not 
> an ARM specific controller.

drivers/pci is currently only used for the PCI bus infrastructure.  The
setup of host bridges is very platform dependent.

Also note that you should *avoid* DMA bounce wherever possible.
The code is broken as designed.  Ensure that the DMA mask is set
appropriately, and then moan elsewhere if things don't work.
