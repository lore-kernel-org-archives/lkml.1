Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbZIASjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbZIASjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 14:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754524AbZIASjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 14:39:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51354 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939AbZIASjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 14:39:20 -0400
Subject: Re: [PATCH 8/8] vm: Add an tuning knob for vm.max_writeback_pages
From: Peter Zijlstra <peterz@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       tytso@mit.edu, akpm@linux-foundation.org, jack@suse.cz
In-Reply-To: <1251803946-9243-9-git-send-email-jens.axboe@oracle.com>
References: <1251803946-9243-1-git-send-email-jens.axboe@oracle.com>
	 <1251803946-9243-9-git-send-email-jens.axboe@oracle.com>
Content-Type: text/plain
Date: Tue, 01 Sep 2009 20:38:55 +0200
Message-Id: <1251830335.8502.17.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-01 at 13:19 +0200, Jens Axboe wrote:

> Originally, MAX_WRITEBACK_PAGES was hard-coded to 1024 because of a
> concern of not holding I_SYNC for too long.  (At least, that was the
> comment previously.)  This doesn't make sense now because the only
> time we wait for I_SYNC is if we are calling sync or fsync, and in
> that case we need to write out all of the data anyway.  Previously
> there may have been other code paths that waited on I_SYNC, but not
> any more.
> 
> According to Christoph, the current writeback size is way too small,
> and XFS had a hack that bumped out nr_to_write to four times the value
> sent by the VM to be able to saturate medium-sized RAID arrays.  This
> value was also problematic for ext4 as well, as it caused large files
> to be come interleaved on disk by in 8 megabyte chunks (we bumped up
> the nr_to_write by a factor of two).
> 
> So, in this patch, we make the MAX_WRITEBACK_PAGES a tunable, and
> change the default to be 32768 blocks.

Do we really need a tunable for this?

I guess we need a limit to avoid it writing out everything, but can't we
have something automagic?

