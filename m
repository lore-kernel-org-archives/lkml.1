Return-Path: <linux-kernel-owner+w=401wt.eu-S1757158AbYGOMK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158AbYGOMK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 08:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755429AbYGOMKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 08:10:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950AbYGOMKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 08:10:14 -0400
Date: Tue, 15 Jul 2008 08:09:53 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@devserv.devel.redhat.com
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
cc: davem@davemloft.net, andi@firstfloor.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [SUGGESTION]: drop virtual merge accounting in I/O requests
In-Reply-To: <20080715114058A.fujita.tomonori@lab.ntt.co.jp>
Message-ID: <Pine.LNX.4.64.0807150759430.12202@devserv.devel.redhat.com>
References: <20080713.202035.172246136.davem@davemloft.net>
 <20080715024424R.fujita.tomonori@lab.ntt.co.jp>
 <Pine.LNX.4.64.0807141720350.30981@devserv.devel.redhat.com>
 <20080715114058A.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> BTW. what should the block device driver do when it receives a mapping
>> error? (if it aborts the request and it was write request, there will be
>> data corruption).
>
> I'm not sure how a aborted request can corrupt data on disk.

Writes are done by an async daemon and no one checks for their completion 
status. If there are three writes to directory, inode table and inode 
bitmap and one of these writes fail, there's no code to undo the other 
two. So the filesystem will be corrupted on write failure.

>> Is it even legal to return IOMMU error in case where no
>> real hardware error or overflow happened?
>
> Of course, it's legal. It's a common event like kinda OOM. It's very
> possible with old IOMMUs that have the small I/O space. A SCSI driver
> retries a failed request later. But note that some drivers are still
> not able to handle that.
>
> http://marc.info/?l=linux-kernel&m=121300637114672&w=2

So should it return SCSI_MLQUEUE_HOST_BUSY? Or something other?

Unfortunatelly, many of the drivers contain BUG_ON or no check at all.

Mikulas
