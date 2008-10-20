Return-Path: <linux-kernel-owner+w=401wt.eu-S1753674AbYJTSeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674AbYJTSeq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 14:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbYJTSeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 14:34:36 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:54039 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260AbYJTSef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 14:34:35 -0400
Date: Mon, 20 Oct 2008 20:33:42 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Dmitri Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Add block device speciffic splice write method
Message-ID: <20081020183341.GL19428@kernel.dk>
References: <1224424858-3927-1-git-send-email-dmonakhov@openvz.org> <20081020174931.GH19428@kernel.dk> <m363nnf7c4.fsf@dmon-lap.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m363nnf7c4.fsf@dmon-lap.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20 2008, Dmitri Monakhov wrote:
> Jens Axboe <jens.axboe@oracle.com> writes:
> 
> > On Sun, Oct 19 2008, Dmitri Monakhov wrote:
> >> Block device write procedure is different from regular file:
> >>  - Actual write performed without i_mutex.
> >>  - It has no metadata, so generic_osync_inode(O_SYNCMETEDATA) can not livelock.
> >>  - We do not have to worry about S_ISUID/S_ISGID bits.
> >
> > I already did an O_DIRECT part of block device splicing [1], I'll fold
> > this into the splice branch and double check with some testing.
> >
> > [1] http://git.kernel.dk/?p=linux-2.6-block.git;a=commitdiff;h=fbb724a0484aba938024d41ca1dd86337d2550c9;hp=08c7910b275a4c580ad646ae8654439c8dfae4c5
> Ok i've missed this branch :(, your approach is really cool.
> But current patch seems not completely ready, 

Not surprising, it's still pretty fresh. The core of it works, which was
the first objective :-)

> O_DIRECT case:
>   - sync case missed, some one may want use it with O_DIRECT|O_SYNC

Good point, I'll update that to wait on in-progress bios.

>   - i'm not sure why it is necessary to always hold bd_inode->i_mutex
>     inside __splice_on_pice(.., pipe_to_disk)

It is not, I'll drop that too.

> !O_DIRECT case:
>   - still use generic_file_splice_write

Well, the patch adds O_DIRECT support, so that's not really a missing
piece!

> So I'll re-base to your patch and:
>  - add appropriate fixes  necessary fixes for direct case.
>  - redone my patch on top of yours for buffered writes.
> 
> What do you think?

Please just send a patch for the missing bits on top of the current
splice branch, that includes the patch I sent which is a rebased version
of yours.

-- 
Jens Axboe

