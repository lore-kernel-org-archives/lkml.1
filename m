Return-Path: <linux-kernel-owner+w=401wt.eu-S1753417Ab0AMMIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab0AMMIM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 07:08:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165Ab0AMMIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 07:08:11 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:50948 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133Ab0AMMIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 07:08:10 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Nick Piggin <npiggin@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] vfs: Fix vmtruncate() regression
References: <876378jxhx.fsf@devron.myhome.or.jp> <20100113060734.GC3901@nick>
Date: Wed, 13 Jan 2010 21:07:59 +0900
In-Reply-To: <20100113060734.GC3901@nick> (Nick Piggin's message of "Wed, 13
	Jan 2010 17:07:34 +1100")
Message-ID: <87r5pucin4.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@suse.de> writes:

>> If __block_prepare_write() was failed in block_write_begin(), the
>> allocated blocks can be outside of ->i_size.
>> 
>> But new truncate_pagecache() in vmtuncate() does nothing if new < old.
>> It means the above usage is not working anymore.
>> 
>> So, this patch fixes it by removing "new < old" check. It would need
>> more cleanup/change. But, now -rc and truncate working is in progress,
>> so, this tried to fix it minimum change.
>> 
>> Cc: stable@kernel.org
>> Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
> Hmm, truncate_pagecache() is for truncating the mm/vm part of the
> pagecache. vmtruncate should still call inode->i_op->truncate() to
> trim blocks if required.
>
> However I'd say we do still need to ensure do_invalidatepage is
> called for the page, for private metadata. So yes I think your patch
> looks good.

Thanks for reviewing. Yes, and it also needs to be called to ensure that
have the same state on-disk and page/bh state. [BTW, this became the
cause of fatfs corruption.]

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
