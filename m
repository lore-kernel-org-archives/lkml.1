Return-Path: <linux-kernel-owner+w=401wt.eu-S1760281AbYCFE5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760281AbYCFE5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 23:57:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757524AbYCFE5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 23:57:22 -0500
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:57786 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755651AbYCFE5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 23:57:21 -0500
To: htejun@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, tomof@acm.org, efault@gmx.de,
       jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       jgarzik@pobox.com, bzolnier@gmail.com
Subject: Re: [PATCH] block: fix residual byte count handling
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <47CDECD1.6070601@gmail.com>
References: <47CDDC31.4070806@gmail.com>
	<20080305092619Y.fujita.tomonori@lab.ntt.co.jp>
	<47CDECD1.6070601@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080306135627P.fujita.tomonori@lab.ntt.co.jp>
Date: Thu, 06 Mar 2008 13:56:27 +0900
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Mar 2008 09:44:01 +0900
Tejun Heo <htejun@gmail.com> wrote:

> >> Things going the other way is fine with me but I at least want to hear a
> >> valid rationale.  Till now all I got is "because that's the true size"
> >> which doesn't really make much sense to me.
> > 
> > Most of users of request structure care about only the real data
> > length, don't care about padding and drain length. Why do they bother
> > to use a helper function to get the real data length?
> 
> I think this is where the difference comes from.  To me it seems
> internal usage seems more wide-spread and more delicate and not too many
> care about the true size and when they do only in well defined places.
> Maybe it comes from the difference between your most and my most.

I don't think that they only in well defined places.

If you see scsi mid-layer (and LLDs), you can find several places that
use rq->data_len as the true data length.

Breaking rq->data_len == the true data length theoretically
wrong. Even if it affects only libata now, it will hurt us, I think.
