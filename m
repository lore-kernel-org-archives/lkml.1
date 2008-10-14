Return-Path: <linux-kernel-owner+w=401wt.eu-S1756024AbYJNIJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbYJNIJX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 04:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbYJNIJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 04:09:07 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:13787 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbYJNIJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 04:09:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:newsgroups:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding:from
         :sender;
        b=jfGKo9U1As49Pfw57M+/IarVvu5mjaf4fDp1rnA4YNA5/yAo18s8HI5qxzy+x+V5IV
         rN25qwT6K9CkRF+O7uQ6EEtOyWJdZY8s8Xkp8U19vF1qP1YT+8V4Q9U2Yn77fd1EnuU3
         y14u8HPWHtiorD2BIdtkTllt6NPSaE5mLBCrc=
Message-ID: <48F4539A.5000102@tuffmail.co.uk>
Date: Tue, 14 Oct 2008 09:08:58 +0100
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Jens Axboe <jens.axboe@oracle.com>
CC: jeff@garzik.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: QUEUE_FLAG_NONROT
References: <20081014095017.265faf37@mjolnir.drzeus.cx> <20081014075407.GU19428@kernel.dk>
In-Reply-To: <20081014075407.GU19428@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Alan Jenkins <aj504@student.cs.york.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Tue, Oct 14 2008, Pierre Ossman wrote:
>> Hi Jeff,
>>
>> I noticed you've added a new flag to indicate that the drive has no
>> seek costs and I figured it would be a good idea to use that on the
>> MMC/SD cards.
> 
> That was me, actually...
> 
>> Since the name isn't entirely clear in what is implied, I just wanted
>> to check that there are no plans to assume that there is negligable
>> request overhead for queues with this flag. I.e. the flag should
>> indicate that the elevator doesn't have to care about seeks, but it
>> should still try to merge requests to reduce the transaction overhead.
> 
> Sounds about right. The flag is just meant to indicate zero-seek cost,
> as devices will still have per-command overheads, merging is still
> applicable.
> 
> So yes, you want to set that flag for mmc/sd cards, definitely.

Is there a way for users to get / set it manually?  Can hdparm / sdparm / sg_inq tell me whether my device sets the flag... I think you said it was word 0x217 in a recent draft, but I don't know how I could query that as a user.

I'd like to know whether the SSD in my netbook provides the right flag - and if not, set it manually, instead of having to force the noop io scheduler.

It might also be possible to write a udev test program, which would be guaranteed exclusive access, to measure seek times and set the flag appropriately.  I assume we wouldn't be able to rely on USB flash drives having the right flag set.

Thanks
Alan
