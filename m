Return-Path: <linux-kernel-owner+w=401wt.eu-S1759559AbZCXLhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759559AbZCXLhU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 07:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbZCXLhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 07:37:05 -0400
Received: from brick.kernel.dk ([93.163.65.50]:59936 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbZCXLhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 07:37:04 -0400
Date: Tue, 24 Mar 2009 12:37:01 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, bzolnier@gmail.com,
       =?iso-8859-1?Q?J=F6rg?= Dorchain <joerg@dorchain.net>,
       Geert Uytterhoeven <geert@linux-m68k.org>, Tim Waugh <tim@cyberelk.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Paul Mackerras <paulus@samba.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Grant Likely <grant.likely@secretlab.ca>,
       Markus Lidel <Markus.Lidel@shadowconnect.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Pete Zaitcev <zaitcev@redhat.com>
Subject: Re: [PATCH 15/17] block: kill end_request()
Message-ID: <20090324113701.GL27476@kernel.dk>
References: <1237170540-19130-1-git-send-email-tj@kernel.org> <1237170540-19130-16-git-send-email-tj@kernel.org> <49C457C3.6080909@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C457C3.6080909@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 21 2009, Tejun Heo wrote:
> Tejun Heo wrote:
> > Impact: kill obsolete interface function
> > 
> > end_request() has been kept around for backward compatibility;
> > however, it seems to be about time for it to go away.
> > 
> > * There aren't too many users left.
> > 
> > * Its use of @updtodate is pretty confusing.
> > 
> > * In some cases, newer code ends up using mixture of end_request() and
> >   [__]blk_end_request[_all](), which is way too confusing.
> > 
> > So, kill it.
> > 
> > Most conversions are straightforward.  Noteworthy ones are...
> > 
> > * paride/pcd: next_request() updated to take 0/-errno instead of 1/0.
> > 
> > * paride/pf: pf_end_request() and next_request() updated to take
> >   0/-errno instead of 1/0.
> > 
> > * xd: xd_readwrite() updated to return 0/-errno instead of 1/0.
> > 
> > * mtd/mtd_blkdevs: blktrans_discard_request() updated to return
> >   0/-errno instead of 1/0.  Unnecessary local variable res
> >   initialization removed from mtd_blktrans_thread().
> 
> This patch isn't correct.  Will post updated version later.

The patchset is no longer in the for-2.6.30 upstream branch of the block
git repo, due to the this glitch and the debate on ide conflicts (which
I still find extremely silly and an over reaction).

I trust you will resend it when you are ready!

-- 
Jens Axboe

