Return-Path: <linux-kernel-owner+w=401wt.eu-S1760136AbZDWTSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760136AbZDWTSx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 15:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760039AbZDWTS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 15:18:27 -0400
Received: from verein.lst.de ([213.95.11.210]:38928 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754504AbZDWTSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 15:18:25 -0400
Date: Thu, 23 Apr 2009 21:18:17 +0200
From: Christoph Hellwig <hch@lst.de>
To: axboe@kernel.dk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: get_fs_excl/put_fs_excl/has_fs_excl
Message-ID: <20090423191817.GA22521@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stumbled over these gems recently when investigating the
lock_super/unlock_super removal.

These were added in commit 22e2c507c301c3dbbcf91b4948b88f78842ee6c9

        [PATCH] Update cfq io scheduler to time sliced design

which unfortunately doesn't contain any comments about it.  It seems to
be used to allow boosting priority for some sort of central fs metadata
updates, at least what the usage in the reiserfs journal code
looks like that.

Do you happen to have some notes/anecdotes about it so that we can
document it, give it saner naming and use it directly in the
spots that need it (including inside xfs, btrfs, etc) instead of lock_super?

