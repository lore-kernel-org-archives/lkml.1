Return-Path: <linux-kernel-owner+w=401wt.eu-S1763860AbXGPMiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763860AbXGPMiO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 08:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755995AbXGPMiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 08:38:00 -0400
Received: from brick.kernel.dk ([80.160.20.94]:13870 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990AbXGPMh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 08:37:59 -0400
Date: Mon, 16 Jul 2007 14:37:17 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] splice: fix wrong __splice_from_pipe() usage
Message-ID: <20070716123716.GK5195@kernel.dk>
References: <877ip1qj29.fsf@duaron.myhome.or.jp> <20070716063435.GG5328@kernel.dk> <87odiczkky.fsf@duaron.myhome.or.jp> <20070716111528.GD5195@kernel.dk> <87hco4v847.fsf@duaron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87hco4v847.fsf@duaron.myhome.or.jp>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16 2007, OGAWA Hirofumi wrote:
> Jens Axboe <jens.axboe@oracle.com> writes:
> 
> >> nfsd_vfs_read() path.
> >> 
> >> nfsd_vfs_read()
> >>     splice_direct_to_actor()
> >>         while(len) {
> >>             do_splice_to()                     [update sd->pos]
> >>                 -> generic_file_splice_read()  [read from sd->pos]
> >>             nfsd_direct_splice_actor()
> >>                 -> __splice_from_pipe()        [update sd->pos]
> >>         }
> >> 
> >> do_splice_to() updates sd->pos for read, and pass updated sd to
> >> __splice_from_pipe(), and __splice_from_pipe() updates sd->pos for
> >> write. So, next do_splice_to() read from wrong position.
> >
> > Ah, I see. Copying the structure over would work, but it seems like a
> > big work-around for something that is essentially bad behaviour in the
> > splice core for direct splicing.
> >
> > Can you check if this works for you?
> 
> Simple test was done. The patch works for me.

Great, thanks a lot for retesting. I'll get the patch upstream asap.

-- 
Jens Axboe

