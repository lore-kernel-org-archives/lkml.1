Return-Path: <linux-kernel-owner+w=401wt.eu-S1760077AbYCCI2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760077AbYCCI2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 03:28:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbYCCI2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 03:28:25 -0500
Received: from tama555.ecl.ntt.co.jp ([129.60.39.106]:43781 "EHLO
	tama555.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbYCCI2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 03:28:24 -0500
To: htejun@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, tomof@acm.org, jens.axboe@oracle.com,
       James.Bottomley@HansenPartnership.com, efault@gmx.de,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       jgarzik@pobox.com
Subject: Re: [PATCH] block: fix residual byte count handling
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <47CB79E9.8000505@gmail.com>
References: <47CB6508.3040206@gmail.com>
	<20080303125940T.fujita.tomonori@lab.ntt.co.jp>
	<47CB79E9.8000505@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080303172623O.fujita.tomonori@lab.ntt.co.jp>
Date: Mon, 03 Mar 2008 17:26:23 +0900
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Mar 2008 13:09:13 +0900
Tejun Heo <htejun@gmail.com> wrote:

> FUJITA Tomonori wrote:
> >> - I think bugs caused by using raw_data_len instead of data_len are more
> >> subtle than the other way around.  Using data_len instead of
> >> raw_data_len usually affects the application layer while using
> >> raw_data_len instead of data_len affects the DMA engine and transport layer.
> > 
> > If we add extra_len, we can get what raw_data_len and data_len
> > provide.
> > 
> > I can't see what changing the meaning of rq->data_len (and
> > investigating all the block drivers) gives us.
> 
> No matter which way you go, you change the meaning of rq->data_len and
> you MUST inspect rq->data_len usage whichever way you go.

The patch doens't change that rq->data_len means the true data
length. But yeah, it breaks rq->data_len == sum(sg). So it might break
some drivers.


> Apply your patch and try to do sg IO on IDE cdrom w/ various
> transfer lengths.

I've just tried the patch with both ata and libata and it seems to
work.

For anyone hitting this problem, please try the following patch:

http://lkml.org/lkml/2008/3/2/218


Thanks,
