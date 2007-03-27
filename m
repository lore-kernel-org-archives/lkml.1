Return-Path: <linux-kernel-owner+w=401wt.eu-S934057AbXC0F7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934057AbXC0F7Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 01:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934058AbXC0F7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 01:59:24 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33172 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934057AbXC0F7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 01:59:23 -0400
Message-ID: <4608B2B9.7090503@garzik.org>
Date: Tue, 27 Mar 2007 01:59:21 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: Why is NCQ enabled by default by libata? (2.6.20)
References: <Pine.LNX.4.64.0703241232580.11608@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0703241232580.11608@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> Without NCQ, performance is MUCH better on almost every operation, with 
> the exception of 2-3 items.

Variables to take into account:

* the drive (NCQ performance wildly varies)
* the IO scheduler
* the filesystem (if not measuring direct to blkdev)
* application workload (or in your case, benchmark tool)
	* in particular, the threaded-ness of the apps

For the overwhelming majority of combinations, NCQ should not /hurt/ 
performance.

For the majority of combinations, NCQ helps (though it may not be often 
that you use more than 4-8 tags).

In some cases, NCQ firmware may be broken.  There is a Maxtor firmware 
id, and some Hitachi ids that people are leaning towards recommending be 
added to the libata 'horkage' list.

	Jeff


