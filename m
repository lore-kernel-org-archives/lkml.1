Return-Path: <linux-kernel-owner+w=401wt.eu-S1754426AbXLDVoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426AbXLDVoG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:44:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbXLDVnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:43:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:32873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbXLDVnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:43:50 -0500
Date: Tue, 04 Dec 2007 16:37:49 -0500 (EST)
Message-Id: <20071204.163749.39152828.k-ueda@ct.jp.nec.com>
To: bharrosh@panasas.com, jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com
Subject: Re: [PATCH 01/28] blk_end_request: add new request completion
 interface (take 3)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
In-Reply-To: <47555C90.2080609@panasas.com>
References: <20071130.182422.18574732.k-ueda@ct.jp.nec.com>
	<47555C90.2080609@panasas.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boaz and Jens,

On Tue, 04 Dec 2007 15:56:32 +0200, Boaz Harrosh <bharrosh@panasas.com> wrote:
> > +/**
> > + * blk_end_request - Helper function for drivers to complete the request.
> > + * @rq:       the request being processed
> > + * @uptodate: 1 for success, 0 for I/O error, < 0 for specific error
> > + * @nr_bytes: number of bytes to complete
> > + *
> > + * Description:
> > + *     Ends I/O on a number of bytes attached to @rq.
> > + *     If @rq has leftover, sets it up for the next range of segments.
> > + *
> > + * Return:
> > + *     0 - we are done with this request
> > + *     1 - still buffers pending for this request
> > + **/
> > +int blk_end_request(struct request *rq, int uptodate, int nr_bytes)
> 
> I always hated that uptodate boolean with possible negative error value.
> I guess it was done for backward compatibility of then users of 
> end_that_request_first(). But since you are introducing a new API then
> this is not the case. Just have regular status int where 0 means ALL_OK
> and negative value means error code. 
> Just my $0.02.

Thank you for the comment.
I think it's quite reasonable.
By doing that, we don't need end_io_error() anymore.


Jens,
What do you think?
If you agree with the interface change above, I would prefer to
separate the patch-set from blk_end_request patch-set like below:
    o blk_end_request: remove end_that_request_*
    o change interface of 'uptodate' in blk_end_request to 'error'
It makes the purpose of blk_end_request patch-set clear
(and also, each patch of device drivers could be smaller).
But, it doubles your merging work.  So if you would like to get
the changes at once, I'll merge them into blk_end_request patch-set.
 
As for the patch inclusion, do you push the driver changes to Linus
all at once?  Or should I ask each maintainer to take the patch?

Thanks,
Kiyoshi Ueda
