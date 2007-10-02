Return-Path: <linux-kernel-owner+w=401wt.eu-S1754543AbXJBXXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbXJBXXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 19:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752357AbXJBXXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 19:23:14 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38966 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697AbXJBXXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 19:23:13 -0400
Message-ID: <4702D2DE.1050504@pobox.com>
Date: Tue, 02 Oct 2007 19:23:10 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [regression] 2.6.23 sata_mv EH updates broke my 7042 controller
References: <20071001220439.GA15332@lixom.net> <470176B8.1000109@pobox.com> <20071002023000.GA19286@lixom.net>
In-Reply-To: <20071002023000.GA19286@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Olof Johansson wrote:
> On Mon, Oct 01, 2007 at 06:37:44PM -0400, Jeff Garzik wrote:
>> Olof Johansson wrote:
>>> Hardware config in my case:
>>> Highpoint 2310 controller
>>> PPC (big endian)
>>> WD Raptor disk
>>> Works fine with the other controller I've been using (SIL24), and works
>>> fine if I revert the driver.
>>> It also works fine if I disable the IOMMU. This would point towards
>>> either a stale dma mapping, or a missing setup of one.
>>> Not being much at home in the SATA drivers I could keep digging but I
>>> figured I'd bring it up first in case it rings a bell for someone.
>> The IOMMU data point is certainly interesting.  Nothing jumps out on a 
>> re-review of the patch, so keep digging and let us know ;-)
> 
> Looks like it's caused by enabling vmerge (which tends to be on for the
> common PPC defconfigs). If I disable it, things look OK.
> 
> Perhaps the Marvell controller doesn't like requests larger than 64K,
> or wrapping some boundary. Do you have access to erratas/docs?
> 
> I have verified it on a powermac now as well (had a quick scare that it
> might have been some problem with the PA Semi IOMMU, but no).

FWIW:  I just tried the 6042 on my AMD64 platform with iommu=force, and 
was unable to reproduce any trouble.

You could try changing MV_DMA_BOUNDARY to 0xffffU and see what happens.

I'll also look through my errata, to see what is different between 6042 
and 7042, if anything.

	Jeff


