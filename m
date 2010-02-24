Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab0BXANZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 19:13:25 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:39350 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307Ab0BXANX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 19:13:23 -0500
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] block: warn if blk_stack_limits() undermines atomicity
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20100222204920.GA24514@redhat.com>
	<yq1635nop2j.fsf@sermon.lab.mkp.net>
	<20100223193241.GB24662@redhat.com>
Date: Tue, 23 Feb 2010 19:12:50 -0500
In-Reply-To: <20100223193241.GB24662@redhat.com> (Mike Snitzer's message of
	"Tue, 23 Feb 2010 14:32:41 -0500")
Message-ID: <yq1sk8rmqyl.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4B846F0B.008E:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

>> Not really.  It'll be issued as one I/O with a smaller LBA count but
>> an identical data payload.

Mike> Can you expand on that a bit?  How does a smaller LBA count relate
Mike> to this?  On a 512b device the 4K data payload would touch more
Mike> LBAs.

Sorry, I had my head stuck in the 4KB case.  More blocks.  My point
being that regardless of the logical block size we'll be issuing a
single command.  The only difference between the two cases is the LBA
count. I.e. the protocol encoding of how much data to transfer.


Mike> In any case, a 4K write to a 512b device is not atomic.

Mike> If you think what I've raised here is overblown then I'd like to
Mike> understand why in more detail.

I'm just playing devil's advocate here.  We have no guarantees that a
512-byte write to a 512-byte device is atomic either.  None.  We've been
trying very hard to get any guarantees out of storage vendors for years
without any luck.  I know that a lot of our stuff operate on the
assumption that sector writes are atomic.  But in a lot of cases they
are not.


Mike> Otherwise all you have is a largely generic warning (as
Mike> blk_stack_limits knows nothing about which devices the provided
Mike> limits belong to).

Yeah, I had a patch at some point that distinguished between the various
error conditions instead of returning -1.  I'll see if I can dig that
up...

-- 
Martin K. Petersen	Oracle Linux Engineering
