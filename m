Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbYJ1Mfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbYJ1Mfa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 08:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbYJ1MfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 08:35:13 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:50825 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbYJ1MfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 08:35:11 -0400
Message-ID: <F69DB5CD5C544C428676CFA36F31FF26@nsl.ad.nec.co.jp>
From: "Takashi Sato" <t-sato@yk.jp.nec.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Christoph Hellwig" <hch@infradead.org>, <linux-fsdevel@vger.kernel.org>,
       <dm-devel@redhat.com>, <viro@ZenIV.linux.org.uk>,
       <linux-ext4@vger.kernel.org>, <xfs@oss.sgi.com>,
       <mtk.manpages@googlemail.com>, <axboe@kernel.dk>,
       <linux-kernel@vger.kernel.org>
References: <20081027215855t-sato@mail.jp.nec.com> <20081027231533.96c42a78.akpm@linux-foundation.org>
In-Reply-To: <20081027231533.96c42a78.akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] Implement generic freeze feature
Date: Tue, 28 Oct 2008 21:33:59 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
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

>> -void thaw_bdev(struct block_device *bdev, struct super_block *sb)
>> +int thaw_bdev(struct block_device *bdev, struct super_block *sb)
>>  {
>> + int error = 0;
>> +
>> + mutex_lock(&bdev->bd_fsfreeze_mutex);
>> + if (!bdev->bd_fsfreeze_count) {
>> + mutex_unlock(&bdev->bd_fsfreeze_mutex);
>> + return -EINVAL;
> 
> This would be a programming error, yes?

This is not a kernel programming error but a user's.
thaw_bdev() is called via the unfreeze ioctl.  If a user calls the unfreeze
ioctl for an unfrozen filesystem, this error will be returned.
So a WARN_ON isn't needed.

> If so, a WARN_ON is more appropriate than a silent runtime error.
> 
>> + }

Cheers, Takashi
