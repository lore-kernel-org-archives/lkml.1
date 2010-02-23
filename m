Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab0BWRLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 12:11:46 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:33963 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab0BWRLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 12:11:45 -0500
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] block: warn if blk_stack_limits() undermines atomicity
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20100222204920.GA24514@redhat.com>
Date: Tue, 23 Feb 2010 12:10:44 -0500
In-Reply-To: <20100222204920.GA24514@redhat.com> (Mike Snitzer's message of
	"Mon, 22 Feb 2010 15:49:20 -0500")
Message-ID: <yq1635nop2j.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4B840C2B.021C:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> For instance, a 512 byte device and a 4K device may be combined
Mike> into a single logical DM device; the resulting DM device would
Mike> have a logical_block_size of 4K.  Filesystems layered on such a
Mike> hybrid device assume that 4K will be written atomically but in
Mike> reality that 4K will be split into 8 512 byte IOs when issued to
Mike> the 512 byte device.

Not really.  It'll be issued as one I/O with a smaller LBA count but an
identical data payload.


Mike> Using a 4K logical_block_size for the higher-level DM device
Mike> increases potential for a partial write to the 512b device if
Mike> there is a system crash.

That's a definite maybe :)


Mike> [NOTE: setting "misaligned" for this warning is somewhat awkward
Mike> but blk_stack_limits() return of -1 can be viewed as there was an
Mike> "alignment inconsistency".  Would it be better to return -1 but
Mike> avoid setting t->misaligned?]

I don't have a problem with printing a warning but I don't think this
qualifies as misalignment on the grounds that the error scenario is in
the hypothetical bucket and not a deterministic thing.

-- 
Martin K. Petersen	Oracle Linux Engineering
