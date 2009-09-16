Return-Path: <linux-kernel-owner+w=401wt.eu-S1758710AbZIPSlH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758710AbZIPSlH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 14:41:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755743AbZIPSlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 14:41:05 -0400
Received: from brick.kernel.dk ([93.163.65.50]:46216 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754424AbZIPSlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 14:41:03 -0400
Date: Wed, 16 Sep 2009 20:41:06 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH] fs: Fix busyloop in wb_writeback()
Message-ID: <20090916184106.GT23126@kernel.dk>
References: <1253121768-20673-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253121768-20673-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16 2009, Jan Kara wrote:
> If all inodes are under writeback (e.g. in case when there's only one inode
> with dirty pages), wb_writeback() with WB_SYNC_NONE work basically degrades
> to busylooping until I_SYNC flags of the inode is cleared. Fix the problem by
> waiting on I_SYNC flags of an inode on b_more_io list in case we failed to
> write anything.

Interesting, so this will happen if the dirtier and flush thread end up
"fighting" each other over the same inode. I'll throw this into the
testing mix.

How did you notice?

-- 
Jens Axboe

