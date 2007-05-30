Return-Path: <linux-kernel-owner+w=401wt.eu-S1755396AbXE3QpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396AbXE3QpV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 12:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbXE3QpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 12:45:07 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:17592 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750890AbXE3QpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 12:45:05 -0400
Message-ID: <465DAA15.3070703@cfl.rr.com>
Date: Wed, 30 May 2007 12:45:09 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Stefan Bader <Stefan.Bader@de.ibm.com>,
       Andreas Dilger <adilger@clusterfs.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems,
 and dm/md.
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown> <20070528024559.GA85884050@sgi.com> <465C871F.708@cfl.rr.com> <20070529234832.GT85884050@sgi.com>
In-Reply-To: <20070529234832.GT85884050@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 May 2007 16:45:14.0680 (UTC) FILETIME=[E5968B80:01C7A2D9]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-15208.000
X-TM-AS-Result: No--9.875600-5.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:
>> Barrier != synchronous write,
> 
> Of course. FYI, XFS only issues barriers on *async* writes.
> 
> But barrier semantics - as far as they've been described by everyone
> but you indicate that the barrier write is guaranteed to be on stable
> storage when it returns.

Hrm... I may have misunderstood the perspective you were talking from. 
Yes, when the bio is completed it must be on the media, but the 
filesystem should issue both requests, and then really not care when 
they complete.  That is to say, the filesystem should not wait for block 
A to finish before issuing block B; it should issue both, and use 
barriers to make sure they hit the disk in the correct order.

> XFS relies on the block being stable before any other write
> goes to disk. That is the semantic that the barrier I/Os currently
> have. How that is implemented in the device is irrelevant to me,
> but if I issue a barrier I/O, I do not expect *any* I/O to be
> reordered around it.

Right... it just needs to control the order of the requests, just not 
wait on one to finish before issuing the next.


