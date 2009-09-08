Return-Path: <linux-kernel-owner+w=401wt.eu-S1751360AbZIHOVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360AbZIHOVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 10:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751086AbZIHOVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 10:21:17 -0400
Received: from brick.kernel.dk ([93.163.65.50]:58056 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbZIHOVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 10:21:16 -0400
Date: Tue, 8 Sep 2009 16:21:18 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz
Subject: Re: [PATCH 3/8] writeback: switch to per-bdi threads for flushing
	data
Message-ID: <20090908142118.GZ18599@kernel.dk>
References: <1252401791-22463-1-git-send-email-jens.axboe@oracle.com> <1252401791-22463-4-git-send-email-jens.axboe@oracle.com> <1252417606.14793.3.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252417606.14793.3.camel@desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 08 2009, Daniel Walker wrote:
> On Tue, 2009-09-08 at 11:23 +0200, Jens Axboe wrote:
> > This gets rid of pdflush for bdi writeout and kupdated style cleaning.
> > pdflush writeout suffers from lack of locality and also requires more
> > threads to handle the same workload, since it has to work in a
> > non-blocking fashion against each queue. This also introduces lumpy
> > behaviour and potential request starvation, since pdflush can be starved
> > for queue access if others are accessing it. A sample ffsb workload that
> > does random writes to files is about 8% faster here on a simple SATA drive
> > during the benchmark phase. File layout also seems a LOT more smooth in
> > vmstat:
> 
> 
> This patch has a checkpatch error, and couple of warnings.. Here's one
> of the warnings which I though was concerning..
> 
> WARNING: trailing semicolon indicates no statements, indent implies
> otherwise
> #388: FILE: fs/fs-writeback.c:177:
> +               } else if (wb->task);
> +                       wake_up_process(wb->task);
> 
> I suppose that could be a defect .. btw, patch 7 of 8 also has a few
> trivial warnings.

Oops yes, that was added between -v18 and -19 with the moving of that
code. Will fix that up, thanks for spotting that.

I'll check the series for checkpatch cleanliness. I did at some point,
but that was a few revisions ago.

-- 
Jens Axboe

