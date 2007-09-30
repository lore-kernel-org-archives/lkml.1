Return-Path: <linux-kernel-owner+w=401wt.eu-S1758185AbXI3PFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185AbXI3PFd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 11:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756934AbXI3PFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 11:05:25 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:54977 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756563AbXI3PFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 11:05:24 -0400
Message-ID: <46FFBB2D.6060004@garzik.org>
Date: Sun, 30 Sep 2007 11:05:17 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Paolo Ornati <ornati@fastwebnet.it>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Tejun Heo <htejun@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH] blacklist NCQ on Seagate Barracuda ST380817AS
References: <20070930160548.235be972@localhost>	<20070930152908.1f58d39d@the-village.bc.nu> <20070930164610.20818867@localhost>
In-Reply-To: <20070930164610.20818867@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Ornati wrote:
> On Sun, 30 Sep 2007 15:29:08 +0100
> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
>>> Seagate Barracuda ST380817AS has troubles with NCQ. For example,
>>> unpacking a tarball on an XFS filesystem gives this:
>>>
>>> ata1.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x2 frozen
>>> ata1.00: cmd 61/40:00:29:a3:98/00:00:00:00:00/40 tag 0 cdb 0x0 data 32768 out
>>>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)  
>> What makes you sure that is an NCQ problem ?
> 
> It goes away with:
> echo 1 > /sys/block/sda/device/queue_depth
> 
> I have this problem only with XFS, and even with XFS it goes away
> mounting with "nobarrier"...

This last is an interesting datapoint.

I wonder if libata has a generic problem with NCQ + FLUSH CACHE.

What happens if you enable the 'fua' module parameter?  (libata.fua on 
kernel command line, if built in)

	Jeff



