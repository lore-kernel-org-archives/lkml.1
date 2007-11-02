Return-Path: <linux-kernel-owner+w=401wt.eu-S1757350AbXKBR6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350AbXKBR6g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 13:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760839AbXKBR6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 13:58:20 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41894 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756789AbXKBR6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 13:58:18 -0400
Message-ID: <472B652A.5000900@garzik.org>
Date: Fri, 02 Nov 2007 13:58:02 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Daniel Drake <dsd@gentoo.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jens Axboe <jens.axboe@oracle.com>,
       linux list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Tejun Heo <htejun@gmail.com>, Albert Lee <albertcc@tw.ibm.com>
Subject: Re: "Fix ATAPI transfer lengths" causes CD writing regression
References: <47274A5F.6070409@gentoo.org>	<20071030153417.59b9182c@the-village.bc.nu>	<47276DCA.1000808@gentoo.org>	<20071030190153.373c9347@the-village.bc.nu>	<47278439.4030801@gentoo.org>	<20071031114958.210bd7cc@the-village.bc.nu>	<20071031115754.GK5059@kernel.dk>	<4729A0DF.20800@garzik.org>	<20071101105335.1f20bab3@the-village.bc.nu>	<4729B3EA.6040707@garzik.org> <20071101141501.3746cec2@the-village.bc.nu> <4729F1BB.20306@gentoo.org>
In-Reply-To: <4729F1BB.20306@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Drake wrote:
> Again, ignore me if I'm not contributing anything useful, but I'm 
> increasingly thinking that the SG_IO command block in question is 
> perfectly valid, and doing a short read of the mode page in question 
> (and probably others too) is in fact required before you can know its 
> true size to do a full read anyway.


Correct -- I do not see anything wrong with the SCSI command being 
passed to the device.

It is quite normal to request an allocation length less than the amount 
of data to be returned -- often this is even a requirement, in order for 
the SCSI client to see how much data buffer is must allocate for the 
returned data.

This technique is used all over SCSI, both in userland and in the 
kernel.  Nothing wrong with the test app AFAICS.

This behavior can be adequated summarized as a drive firmware bug, where 
the device will puke when both SCSI allocation length and ATA byte count 
limit are below the amount of data it wishes to return.

At this point I think we're interested to see the output from Tejun's 
debugging patch, posted in this thread.

	Jeff


