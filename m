Return-Path: <linux-kernel-owner+w=401wt.eu-S1754587AbYJTSar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587AbYJTSar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 14:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbYJTSag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 14:30:36 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:35784 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008AbYJTSag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 14:30:36 -0400
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Add block device speciffic splice write method
References: <1224424858-3927-1-git-send-email-dmonakhov@openvz.org>
	<20081020174931.GH19428@kernel.dk>
From: Dmitri Monakhov <dmonakhov@openvz.org>
Date: Mon, 20 Oct 2008 22:29:47 +0400
In-Reply-To: <20081020174931.GH19428@kernel.dk> (Jens Axboe's message of "Mon\, 20 Oct 2008 19\:49\:32 +0200")
Message-ID: <m363nnf7c4.fsf@dmon-lap.sw.ru>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> writes:

> On Sun, Oct 19 2008, Dmitri Monakhov wrote:
>> Block device write procedure is different from regular file:
>>  - Actual write performed without i_mutex.
>>  - It has no metadata, so generic_osync_inode(O_SYNCMETEDATA) can not livelock.
>>  - We do not have to worry about S_ISUID/S_ISGID bits.
>
> I already did an O_DIRECT part of block device splicing [1], I'll fold
> this into the splice branch and double check with some testing.
>
> [1] http://git.kernel.dk/?p=linux-2.6-block.git;a=commitdiff;h=fbb724a0484aba938024d41ca1dd86337d2550c9;hp=08c7910b275a4c580ad646ae8654439c8dfae4c5
Ok i've missed this branch :(, your approach is really cool.
But current patch seems not completely ready, 
O_DIRECT case:
  - sync case missed, some one may want use it with O_DIRECT|O_SYNC
  - i'm not sure why it is necessary to always hold bd_inode->i_mutex
    inside __splice_on_pice(.., pipe_to_disk)
!O_DIRECT case:
  - still use generic_file_splice_write

So I'll re-base to your patch and:
 - add appropriate fixes  necessary fixes for direct case.
 - redone my patch on top of yours for buffered writes.

What do you think?
