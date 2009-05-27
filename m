Return-Path: <linux-kernel-owner+w=401wt.eu-S1759993AbZE0FVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759993AbZE0FVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 01:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755763AbZE0FVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 01:21:01 -0400
Received: from smtp-102-tuesday.noc.nerim.net ([62.4.17.102]:53038 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755368AbZE0FVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 01:21:00 -0400
X-Greylist: delayed 43935 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 May 2009 01:21:00 EDT
Date: Wed, 27 May 2009 07:21:01 +0200
From: Damien Wyart <damien.wyart@free.fr>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk
Subject: Re: [PATCH 0/12] Per-bdi writeback flusher threads v7
Message-ID: <20090527052101.GA28517@localhost.localdomain>
References: <1243330430-9964-1-git-send-email-jens.axboe@oracle.com>
 <20090526152501.GA20968@localhost.localdomain>
 <20090526164117.GJ11363@kernel.dk>
 <20090526170845.GA3226@localhost.localdomain>
 <20090526204703.GM11363@kernel.dk>
 <20090526211119.GO11363@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526211119.GO11363@kernel.dk>
User-Agent: Mutt/1.5.19 (2009-05-25)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jens Axboe <jens.axboe@oracle.com> [2009-05-26 23:11]:
> > OK, I spotted the problem. If we fallback to the on-stack allocation in
> > bdi_writeback_all(), then we do the wait for the work completion with
> > the bdi_lock mutex held. This can deadlock with bdi_forker_task(), so if
> > we require that to be invoked to make progress (happens if a thread
> > needs to be restarted), then we have a deadlock on that mutex.

> > I'll cook up a fix for this, but probably not before the morning.

> Untested fix. I think it should work, but I haven't run it here yet.

Thanks for your feedback and explanations. Will not be able to test the
patch before the afternoon. Will then give feedback as soon as I can. Of
course, I can also test a new fix or series if you send one in the
morning, after your own testing.


Best

-- 
Damien Wyart
