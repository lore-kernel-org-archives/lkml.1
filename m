Return-Path: <linux-kernel-owner+w=401wt.eu-S1760184AbXJYFiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760184AbXJYFiO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 01:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754848AbXJYFh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 01:37:57 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49546 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753823AbXJYFhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 01:37:55 -0400
Message-ID: <47202BAB.2040709@garzik.org>
Date: Thu, 25 Oct 2007 01:37:47 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, barkalow@iabervon.org, linas@austin.ibm.com,
       chunhao.huang@hotmail.com, gregkh@suse.de, htejun@gmail.com,
       brice.goglin@gmail.com, david.gaarenstroom@gmail.com,
       linux-pci@atrey.karlin.mff.cuni.cz, shane.huang@amd.com,
       linux-ide@vger.kernel.org, brice@myri.com, mchan@broadcom.com
Subject: Re: [PATCH 0/4]: Resolve MSI vs. INTX_DISABLE quirks.
References: <20071023.195108.69018458.davem@davemloft.net>
In-Reply-To: <20071023.195108.69018458.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> The forthcoming patches are also available from:
> 
> 	kernel.org:/pub/scm/linux/kernel/git/davem/msiquirk-2.6.git
> 
> and clean up the handling of the common quirk wherein setting
> INTX_DISABLE will mistakedly disable MSI generation for some
> devices.
> 
> For devices without that problem, we want to keep the pci_intx() calls
> in drivers/pci/msi.c because those help protect against devices
> with the opposite problem.  Such devices always generate INTX
> interrupts even when MSI is enabled, unless INTX_DISABLE is set.
> 
> Michael, please pay special attention to patch #3.  I think I
> picked the correct PCI device IDs to match for the quirk
> (5714* and 5780*) but it's possible we might need more elaborate
> checks here.  It at least worked properly for the chips in my
> Niagara system.
> 
> In addition to the Tigon3 cases, I added quirk entries for the
> SB700/800 SATA chips and the IXP SB400 USB controllers.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>

I'm happy with this patch series.  A quirk is better than a 
sledgehammer, and MSI-mode SATA is better than INTX-mode SATA :)

	Jeff



