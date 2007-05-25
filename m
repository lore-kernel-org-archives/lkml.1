Return-Path: <linux-kernel-owner+w=401wt.eu-S1762471AbXEYOti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762471AbXEYOti (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 10:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759708AbXEYOtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 10:49:32 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:45195 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759531AbXEYOtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 10:49:31 -0400
Message-ID: <4656F783.3000603@cfl.rr.com>
Date: Fri, 25 May 2007 10:49:39 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>
CC: David Chinner <dgc@sgi.com>, linux-fsdevel@vger.kernel.org,
       linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] Re: [RFD] BIO_RW_BARRIER - what it means for devices,
 filesystems, and dm/md.
References: <18006.38689.818186.221707@notabene.brown> <20070525111557.GP85884050@sgi.com> <20070525114910.GQ7653@kernel.dk>
In-Reply-To: <20070525114910.GQ7653@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 May 2007 14:49:39.0244 (UTC) FILETIME=[EBAE3EC0:01C79EDB]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-15198.000
X-TM-AS-Result: No--5.752800-5.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> A barrier write will include a flush, but it may also use the FUA bit to
> ensure data is on platter. So the only situation where a fallback from a
> barrier to flush would be valid, is if the device lied and told you it
> could do FUA but it could not and that is the reason why the barrier
> write failed. If that is the case, the block layer should stop using FUA
> and fallback to flush-write-flush. And if it does that, then there's
> never a valid reason to switch from using barrier writes to
> blkdev_issue_flush() since both methods would either both work or both
> fail.

IIRC, the FUA bit only forces THAT request to hit the platter before it 
is completed; it does not flush any previous requests still sitting in 
the write back queue.  Because all io before the barrier must be on the 
platter as well, setting the FUA bit on the barrier request means you 
don't have to follow it with a flush, but you still have to precede it 
with a flush.

> It's not block layer breakage, it's a device issue.

How isn't it block layer breakage?  If the device does not support 
barriers, isn't it the job of the block layer ( probably the scheduler ) 
to fall back to flush-write-flush?


