Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783AbZEZP03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbZEZP03 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 11:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755941AbZEZP0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 11:26:21 -0400
Received: from mailhost-k7-m1.nerim-networks.com ([78.40.49.172]:57311 "EHLO
	smtp-delay2.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755477AbZEZP0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 11:26:21 -0400
Date: Tue, 26 May 2009 17:25:01 +0200
From: Damien Wyart <damien.wyart@free.fr>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk
Subject: Re: [PATCH 0/12] Per-bdi writeback flusher threads v7
Message-ID: <20090526152501.GA20968@localhost.localdomain>
References: <1243330430-9964-1-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243330430-9964-1-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.19 (2009-05-25)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have been playing with v7 since your sending and after a white (short
on laptop, longer on desktop, a few hours), writeback doesn't seem to
work anymore. Manual call to sync hangs (process in D state) and Dirty
value in meminfo gets growing. As previous versions had been heavily
tested, I guess there is some regression in v7.


Best

Damien Wyart

> Here's the 7th version of the writeback patches. Changes since
> v5/v6:

> - Move the sync_supers() to the global bdi_forker_task() thread, so we
>   don't writeback the supers from all the bdi kupdated() tasks.
> - Make bdi_start_writeback() and bdi_writeback_all() be sync when called
>   with WB_SYNC_ALL only.
> - Shuffle some more things around to make a cleaner series. The sync vs
>   async nature of bdi_writeback_all() and bdi_start_writeback() isn't
>   consistent through the series, but otherwise things should be sane.

> I'd appreciate if Richard and Yanmin could re-run testing with this,
> just to make sure that things are sane. For ease of patching, I've
> put the full diff here:

>   http://kernel.dk/writeback-v7.patch

> and also stored this in a writeback-v7 branch that will not change,
> you can pull that into Linus tree from here:

>   git://git.kernel.dk/linux-2.6-block.git writeback-v7


-- 
Damien Wyart
