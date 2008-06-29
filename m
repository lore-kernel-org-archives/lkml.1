Return-Path: <linux-kernel-owner+w=401wt.eu-S1755947AbYF2XO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947AbYF2XO0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 19:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbYF2XOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 19:14:14 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:39550 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbYF2XOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 19:14:12 -0400
Message-Id: <C2E97AF9310E467696FA7F4C62C88AC5@nsl.ad.nec.co.jp>
From: "Takashi Sato" <t-sato@yk.jp.nec.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <viro@ZenIV.linux.org.uk>, <linux-ext4@vger.kernel.org>, <xfs@oss.sgi.com>,
       <dm-devel@redhat.com>, <linux-fsdevel@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <axboe@kernel.dk>,
       <mtk.manpages@googlemail.com>
References: <20080624160056t-sato@mail.jp.nec.com><20080624150925.765155f0.akpm@linux-foundation.org><7B349EFCD35842D4ADAEB402D2BDCA4E@nsl.ad.nec.co.jp> <20080627115727.149dcb2e.akpm@linux-foundation.org>
In-Reply-To: <20080627115727.149dcb2e.akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] Add timeout feature
Date: Mon, 30 Jun 2008 08:13:07 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Windows Mail 6.0.6000.16480
X-MimeOLE: Produced By Microsoft MimeOLE V6.0.6000.16545
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>> >>  case XFS_FSOP_GOING_FLAGS_DEFAULT: {
>> >> - struct super_block *sb = freeze_bdev(mp->m_super->s_bdev);
>> >> + struct super_block *sb = freeze_bdev(mp->m_super->s_bdev, 0);
>> >
>> > Using NULL here is clearer and will, I expect, avoid a sparse warning.
>> 
>> I checked it but I couldn't find a sparse warning in xfs_fsops.c.
>> Can you tell me how to use NULL?
> 
> struct super_block *sb = freeze_bdev(mp->m_super->s_bdev, NULL);
> 
> :)
> 
> It's much better to use NULL here rather than literal zero because the
> reader of this code can then say "ah-hah, we're passing in a pointer". 
> Whereas plain old "0" could be a pointer or a scalar.

The second argument's type of freeze_bdev() is "long", not pointer as below.
struct super_block *freeze_bdev(struct block_device *, long timeout_msec);

So "0" is reasonable, isn't it?

> We should always use NULL to represent a null pointer in the kernel. 
> The one acceptable exception is when testing for nullness:
> 
> if (ptr1)
> if (!ptr2)
> 
> Often people will use
> 
> if (ptr1 != NULL)
> if (ptr2 == NULL)
> 
> in this case as well.  (I prefer the shorter version personally, but
> either is OK).

