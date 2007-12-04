Return-Path: <linux-kernel-owner+w=401wt.eu-S1754425AbXLDOKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425AbXLDOKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 09:10:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbXLDOKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 09:10:25 -0500
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:37046 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbXLDOKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 09:10:24 -0500
Message-ID: <47555F98.8030504@panasas.com>
Date: Tue, 04 Dec 2007 16:09:28 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       dm-devel@redhat.com, j-nomura@ce.jp.nec.com
Subject: Re: [PATCH 00/28] blk_end_request: full I/O completion handler	(take
 3)
References: <20071130.182351.115904044.k-ueda@ct.jp.nec.com> <20071204121623.GQ23294@kernel.dk>
In-Reply-To: <20071204121623.GQ23294@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04 2007 at 14:16 +0200, Jens Axboe <axboe@kernel.dk> wrote:
> On Fri, Nov 30 2007, Kiyoshi Ueda wrote:
>> Hello Jens,
>>
>> The following is the updated patch-set for blk_end_request().
>> Changes since the last version are only minor updates to catch up
>> with the base kernel changes.
>> Do you agree the implementation of blk_end_request()?
>> If there's no problem, could you merge it to your tree?
>> Or does it have to be merged to -mm tree first?
>>
>>
>> Boaz,
>> Could you review the newly added PATCH 27 which converts the bidi part,
>> and give me your comments?
>> It uses blk_end_request_callback() in PATCH 25, which was only for
>> the tricky ide-cd driver.
>> If bidi added a 'resid' member to struct request instead of reusing
>> 'data_len' for the other purpose, it could use the standard
>> blk_end_request() instead.
>>
>> ------------------ Changes from the previous post ---------------------
>> Changes between take2 and take3:
>>   o Rebased on top of 2.6.24-rc3-mm2
> 
> OK, so this means that I can't apply it unfortunately. It depends on
> other patches in -mm (bidi).
> 
> SCSI sits on block, so the best approach imho is to base this patchset
> on mainline so I can include the block bits.
> 
> 

I was wishing that the bidi work can go into 2.6.25, I guess that's 
James to say. If so than it is not important what order they go in.

Or the patchset can be submitted in two parts, with scsi and remove-of-
old-API in a later stage. 

Or *rant* Boaz can just rebase his work again *rant*.

Kiyoshi, It's OK, if you have a maintainer that is willing to
accept your work then go head, My code can wait, no problem.
Just resolve the resid issue in scsi_io_completion()
(See my other mail)

Thanks for doing this
Boaz
