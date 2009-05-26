Return-Path: <linux-kernel-owner+w=401wt.eu-S1755676AbZEZJeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676AbZEZJeK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 05:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754681AbZEZJdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 05:33:52 -0400
Received: from brick.kernel.dk ([93.163.65.50]:54764 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090AbZEZJdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 05:33:51 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk
Subject: [PATCH 0/12] Per-bdi writeback flusher threads v7
Date: Tue, 26 May 2009 11:33:38 +0200
Message-Id: <1243330430-9964-1-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here's the 7th version of the writeback patches. Changes since
v5/v6:

- Move the sync_supers() to the global bdi_forker_task() thread, so we
  don't writeback the supers from all the bdi kupdated() tasks.
- Make bdi_start_writeback() and bdi_writeback_all() be sync when called
  with WB_SYNC_ALL only.
- Shuffle some more things around to make a cleaner series. The sync vs
  async nature of bdi_writeback_all() and bdi_start_writeback() isn't
  consistent through the series, but otherwise things should be sane.

I'd appreciate if Richard and Yanmin could re-run testing with this,
just to make sure that things are sane. For ease of patching, I've
put the full diff here:

  http://kernel.dk/writeback-v7.patch

and also stored this in a writeback-v7 branch that will not change,
you can pull that into Linus tree from here:

  git://git.kernel.dk/linux-2.6-block.git writeback-v7

-- 
Jens Axboe

