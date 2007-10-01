Return-Path: <linux-kernel-owner+w=401wt.eu-S1756214AbXJAWh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbXJAWh7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 18:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbXJAWhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 18:37:50 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58516 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbXJAWht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 18:37:49 -0400
Message-ID: <470176B8.1000109@pobox.com>
Date: Mon, 01 Oct 2007 18:37:44 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [regression] 2.6.23 sata_mv EH updates broke my 7042 controller
References: <20071001220439.GA15332@lixom.net>
In-Reply-To: <20071001220439.GA15332@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Olof Johansson wrote:
> Hi,
> 
> I just pulled out my Marvell 7042 SATA controller here to give it a spin
> and noticed that it no longer worked (i.e. init segvs when loading from
> it), etc. 2.6.22 is fine.
> 
> Bisecting (just the file drivers/ata/sata_mv.c) resulted in
> bdd4dddee325a7dce3e84cf48201a06aa8508aa4 popping out as the culprit
> (file version 4537deb5e90b717a725b3d74b58b4bb1d28443d0 is fine).
> 
> Just for sanity checking: Has anyone else used 7042/6042 with the current
> mainline driver?

The update was tested extensively on 6042.  I have a 7042, but haven't 
found a compatible PCI slot here.


> Hardware config in my case:
> Highpoint 2310 controller
> PPC (big endian)
> WD Raptor disk
> 
> Works fine with the other controller I've been using (SIL24), and works
> fine if I revert the driver.
> 
> It also works fine if I disable the IOMMU. This would point towards
> either a stale dma mapping, or a missing setup of one.
> 
> Not being much at home in the SATA drivers I could keep digging but I
> figured I'd bring it up first in case it rings a bell for someone.

The IOMMU data point is certainly interesting.  Nothing jumps out on a 
re-review of the patch, so keep digging and let us know ;-)

	Jeff


