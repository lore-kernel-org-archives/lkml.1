Return-Path: <linux-kernel-owner+w=401wt.eu-S932819AbYDPQmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932819AbYDPQmd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 12:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759800AbYDPQm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 12:42:26 -0400
Received: from brick.kernel.dk ([87.55.233.238]:20774 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759569AbYDPQmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 12:42:25 -0400
Date: Wed, 16 Apr 2008 18:42:19 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Elias Oltmanns <eo@nebensachen.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: Block: Prevent busy looping
Message-ID: <20080416164219.GL12774@kernel.dk>
References: <20080416151305.8788.63912.stgit@denkblock.local> <20080416163152.GK12774@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080416163152.GK12774@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16 2008, Jens Axboe wrote:
> On Wed, Apr 16 2008, Elias Oltmanns wrote:
> > blk_run_queue() as well as blk_start_queue() plug the device on reentry
> > and schedule blk_unplug_work() right afterwards. However,
> > blk_plug_device() takes care of that already and makes sure that there is
> > a short delay before blk_unplug_work() is scheduled. This is important
> > to prevent busy looping and possibly system lockups as observed here:
> > <http://permalink.gmane.org/gmane.linux.ide/28351>.
> 
> If you call blk_start_queue() and blk_run_queue(), you better mean it.
> There should be no delay. The only reason it does blk_plug_device() is
> so that the work queue function will actually do some work. In the newer
> kernels we just do:
> 
>         set_bit(QUEUE_FLAG_PLUGGED, &q->queue_flags);
>         kblockd_schedule_work(q, &q->unplug_work);
> 
> instead, which is much better.

actually that's only in my devel tree, not in mainline yet (which still
does blk_plug_device() instead of just setting the plugged bit).

-- 
Jens Axboe

