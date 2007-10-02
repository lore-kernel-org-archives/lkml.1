Return-Path: <linux-kernel-owner+w=401wt.eu-S1753130AbXJBC0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbXJBC0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 22:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751843AbXJBC0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 22:26:07 -0400
Received: from lixom.net ([66.141.50.11]:52243 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbXJBC0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 22:26:05 -0400
Date: Mon, 1 Oct 2007 21:30:01 -0500
From: Olof Johansson <olof@lixom.net>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [regression] 2.6.23 sata_mv EH updates broke my 7042 controller
Message-ID: <20071002023000.GA19286@lixom.net>
References: <20071001220439.GA15332@lixom.net> <470176B8.1000109@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470176B8.1000109@pobox.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2007 at 06:37:44PM -0400, Jeff Garzik wrote:
> Olof Johansson wrote:
>> Hardware config in my case:
>> Highpoint 2310 controller
>> PPC (big endian)
>> WD Raptor disk
>> Works fine with the other controller I've been using (SIL24), and works
>> fine if I revert the driver.
>> It also works fine if I disable the IOMMU. This would point towards
>> either a stale dma mapping, or a missing setup of one.
>> Not being much at home in the SATA drivers I could keep digging but I
>> figured I'd bring it up first in case it rings a bell for someone.
>
> The IOMMU data point is certainly interesting.  Nothing jumps out on a 
> re-review of the patch, so keep digging and let us know ;-)

Looks like it's caused by enabling vmerge (which tends to be on for the
common PPC defconfigs). If I disable it, things look OK.

Perhaps the Marvell controller doesn't like requests larger than 64K,
or wrapping some boundary. Do you have access to erratas/docs?

I have verified it on a powermac now as well (had a quick scare that it
might have been some problem with the PA Semi IOMMU, but no).


-Olof
