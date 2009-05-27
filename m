Return-Path: <linux-kernel-owner+w=401wt.eu-S1761269AbZE0JVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761269AbZE0JVB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 05:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759280AbZE0JUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 05:20:52 -0400
Received: from brick.kernel.dk ([93.163.65.50]:46655 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756341AbZE0JUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 05:20:51 -0400
Date: Wed, 27 May 2009 11:20:53 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Damien Wyart <damien.wyart@free.fr>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk
Subject: Re: [PATCH 0/12] Per-bdi writeback flusher threads v7
Message-ID: <20090527092052.GV11363@kernel.dk>
References: <1243330430-9964-1-git-send-email-jens.axboe@oracle.com> <20090526152501.GA20968@localhost.localdomain> <20090526164117.GJ11363@kernel.dk> <20090526170845.GA3226@localhost.localdomain> <20090526204703.GM11363@kernel.dk> <20090526211119.GO11363@kernel.dk> <20090527052101.GA28517@localhost.localdomain> <20090527054921.GA4127@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527054921.GA4127@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27 2009, Damien Wyart wrote:
> > > > OK, I spotted the problem. If we fallback to the on-stack allocation in
> > > > bdi_writeback_all(), then we do the wait for the work completion with
> > > > the bdi_lock mutex held. This can deadlock with bdi_forker_task(), so if
> > > > we require that to be invoked to make progress (happens if a thread
> > > > needs to be restarted), then we have a deadlock on that mutex.
> 
> > > > I'll cook up a fix for this, but probably not before the morning.
> 
> > > Untested fix. I think it should work, but I haven't run it here yet.
> 
> > Thanks for your feedback and explanations. Will not be able to test the
> > patch before the afternoon. Will then give feedback as soon as I can. Of
> > course, I can also test a new fix or series if you send one in the
> > morning, after your own testing.
> 
> Just ran a quick test with your fix applied and ran into the same
> problem: manual sync stays in D state. I could capture SysRq-T, I am
> attaching part of the output (which was very big and continuously
> displaying).

Yeah, that patch was still buggy. I have it fixed now locally, I'll post
a v8 within the hour!

-- 
Jens Axboe

