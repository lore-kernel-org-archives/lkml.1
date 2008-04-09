Return-Path: <linux-kernel-owner+w=401wt.eu-S1757146AbYDITxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146AbYDITxB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 15:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754134AbYDITwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 15:52:53 -0400
Received: from brick.kernel.dk ([87.55.233.238]:22566 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768AbYDITww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 15:52:52 -0400
Date: Wed, 9 Apr 2008 21:52:44 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Allard Hoeve <allard@byte.nl>,
       Neil Brown <neilb@suse.de>
Subject: Re: [patch] fix infinite loop in generic_file_splice_read()
Message-ID: <20080409195243.GR12774@kernel.dk>
References: <E1JjcgO-0004q2-VJ@pomaz-ex.szeredi.hu> <20080409115702.79737d7f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080409115702.79737d7f.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09 2008, Andrew Morton wrote:
> On Wed, 09 Apr 2008 17:57:56 +0200
> Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> > generic_file_splice_read() goes into an infinite loop if it races with
> > truncation.  I've found this with fsx-linux on NFS over fuse.
> > 
> > Perhaps the whole while() loop is bogus, but I can't tell from a
> > cursory glance at __generic_file_splice_read() if it will return zero
> > only on EOF, or it can do that for other reasons as well.  In the
> > latter case the loop is obviously needed.
> > 
> > This simplistic patch fixes the issue for me.
> > 
> 
> We found suspicious-looking code in generic_file_splice_read() back in
> February.  See http://lkml.org/lkml/2008/2/29/443.  I suspect that patch
> (if it works) will address the truncate lockup as well - it zaps the loop
> entirely.
> 
> Unfortunately Allard never got back to us (probably because he's running
> 2.6.24 which has a quite different generic_file_splice_read()) and the
> patch didn't get anywhere.

Hmm strange, I was pretty sure I pushed my patch back then. I'll double
check and make sure it gets upstream asap.

> Nobody has tested this at all, to my knowledge.

The original reporter did not, however others did.

-- 
Jens Axboe

