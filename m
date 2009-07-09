Return-Path: <linux-kernel-owner+w=401wt.eu-S1754143AbZGIRVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbZGIRVn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 13:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbZGIRVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 13:21:35 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:43608 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbZGIRVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 13:21:34 -0400
Message-ID: <4A5626F2.7070404@garzik.org>
Date: Thu, 09 Jul 2009 13:20:50 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Tejun Heo <tj@kernel.org>, Boaz Harrosh <bharrosh@panasas.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Niel Lambrechts <niel.lambrechts@gmail.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/4] block: use the same failfast bits for bio and	request
References: <1246610898-22350-1-git-send-email-tj@kernel.org> <1246610898-22350-3-git-send-email-tj@kernel.org> <4A5071E5.8030908@panasas.com> <4A553DA4.4080408@kernel.org> <20090709133746.GA21929@infradead.org>
In-Reply-To: <20090709133746.GA21929@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Thu, Jul 09, 2009 at 09:45:24AM +0900, Tejun Heo wrote:
>> What's more disturbing to me is the different between RQ and BIO
>> flags.  __REQ_* are bit positions, REQ_* are masks while BIO_* are bit
>> positions.  Sadly it seems it's already too late to change that.  I
>> personally an not a big fan of simple accessors or flags defined as
>> bit positions.  They seem to obscure things without much benefit.
> 
> flags as bit positions generally only make sense if you use
> test/set/clear_bit, otherwise they just confuse things.  And the
> accessors are pretty annoying, especially in the block layer.  Trying to
> find the places where a BIO flag has an actual effect is pretty painful
> due to the mix of the different flags and the accessors.

Indeed -- the accessors mean in practice that you always have at least 
_two_ things to grep for, just to catch all accesses.  Block layer is 
pretty bad about that style of usage :/

	Jeff




