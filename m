Return-Path: <linux-kernel-owner+w=401wt.eu-S1759632AbYDCPD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759632AbYDCPD7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 11:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757861AbYDCPDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 11:03:52 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:54698 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757853AbYDCPDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 11:03:52 -0400
Subject: Re: kernel BUG at drivers/block/ub.c:820!
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-kernel@vger.kernel.org, k-ueda@ct.jp.nec.com, j-nomura@ce.jp.nec.com,
       jens.axboe@oracle.com, zaitcev@redhat.com
In-Reply-To: <47F4E694.4060103@panasas.com>
References: <1207212156.5602.5.camel@localhost>
	 <47F4C044.1090609@panasas.com> <1207231045.9155.6.camel@localhost>
	 <47F4E694.4060103@panasas.com>
Content-Type: text/plain
Organization: IBM Corporation
Date: Thu, 03 Apr 2008 17:02:58 +0200
Message-Id: <1207234978.9155.13.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-04-03 at 17:15 +0300, Boaz Harrosh wrote:
> OK So first this confirms that for ages the ub.c driver was leaking
> BIO's
> on first connection. Just that it was never noticed before.
> 
> or that we have a BLOCK_PC at hand but before the 7d699baf patch
> we completed with - rq->hard_nr_sectors << 9 - where now
> blk_rq_bytes(rq)
> will return 218 which is less. Could you also put rq->hard_nr_sectors
> in the print above?
> 
> Did you mange to find what is that 218 bytes command. Put a WARN_ON(1)
> in ub_request_fn_1 for any command that has a blk_rq_bytes(rq) of 218
> so we'll see who issues these commands. And what is the real bug.

I've added a WARN_ON(blk_rq_bytes(rq) == 218) right before the
ub_submit_scsi in ub_request_fn_1. ub_end_rq still reports the odd size
but I get nothing from ub_request_fn_1. Interesting.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


