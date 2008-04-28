Return-Path: <linux-kernel-owner+w=401wt.eu-S934120AbYD1NAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934120AbYD1NAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 09:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932113AbYD1NAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 09:00:42 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:33237 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765822AbYD1NAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 09:00:41 -0400
Message-Id: <2E042A67F72447F6AAA0CC0605DBFA84@nsl.ad.nec.co.jp>
From: "Takashi Sato" <t-sato@yk.jp.nec.com>
To: "Christoph Hellwig" <hch@infradead.org>
Cc: <linux-ext4@vger.kernel.org>, <xfs@oss.sgi.com>, <dm-devel@redhat.com>,
       <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20080428193123t-sato@mail.jp.nec.com> <20080428103719.GA16030@infradead.org>
In-Reply-To: <20080428103719.GA16030@infradead.org>
Subject: Re: [RFC PATCH 1/3] Implement generic freeze feature
Date: Mon, 28 Apr 2008 21:59:55 +0900
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

> On Mon, Apr 28, 2008 at 07:31:23PM +0900, Takashi Sato wrote:
>> + /* Initialize semaphore for freeze. */
>> + sema_init(&bdev->bd_freeze_sem, 1);
>
> The freezing process is already protected by bd_mount_sem, so I don't
> think there's need for another one.
>
[...]
>>  down(&bdev->bd_mount_sem);
>>  sb = get_super(bdev);
>
> I think the protection against double freezes would be better done by
> using a trylock on bd_mount_sem.

bd_mount_sem can protect against only freezes and cannot protect against
unfreezes.  If multiple unfreezes run in parallel,  the multiple up() for
bd_mount_sem might occur incorrectly.

> In fact after that it could be changed
> from a semaphore to a simple test_and_set_bit.

I will consider using test_and_set_bit.

>>  error = -ENOTTY;
>>  break;
>> +
>> + case FIFREEZE: {
>
> This would be better to split intot a small helper ala ioctl_fibmap()
>
>> + case FITHAW: {
>
> Same here.

OK.  I will split small helper functions.

Cheers, Takashi 
