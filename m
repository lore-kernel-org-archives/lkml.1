Return-Path: <linux-kernel-owner+w=401wt.eu-S1760804AbZDGVot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760804AbZDGVot (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 17:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758199AbZDGVoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 17:44:37 -0400
Received: from THUNK.ORG ([69.25.196.29]:49595 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756161AbZDGVoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 17:44:34 -0400
Date: Tue, 7 Apr 2009 17:44:21 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>, jack@suse.cz
Subject: Re: [PATCH 1/3] block_write_full_page: Use synchronous writes for
	WBC_SYNC_ALL writebacks
Message-ID: <20090407214421.GA7031@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jens Axboe <jens.axboe@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>, jack@suse.cz
References: <1238185471-31152-1-git-send-email-tytso@mit.edu> <1238185471-31152-2-git-send-email-tytso@mit.edu> <20090406232141.ebdb426a.akpm@linux-foundation.org> <20090406235052.1ea47513.akpm@linux-foundation.org> <20090407070835.GM5178@kernel.dk> <20090407002313.fcdd1da0.akpm@linux-foundation.org> <20090407075732.GO5178@kernel.dk> <20090407190913.GA31723@mit.edu> <20090407193239.GE5178@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090407193239.GE5178@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07, 2009 at 09:32:39PM +0200, Jens Axboe wrote:
> 
> This should be all you need, forget the below. The manual unplugging
> only really makes sense for very select situations, since it'll be done
> when someone waits on the buffer anyway.

Thanks, ok; I missed the "sync_buffer" in the call to wait_on_bit() in
__wait_on_buffer().  It also wasn't obvious to me that
wait_on_writeback_range() ultimately ends up calling aops->sync_page
which for filemap.c will call blk_run_backing_dev() --- and that
blk_run_*() results in the right device queue getting unplugged.  So
this would be a nice thing to get documented in
Documentation/biodoc.txt.

						- Ted
