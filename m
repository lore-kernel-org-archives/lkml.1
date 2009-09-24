Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbZIXPDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbZIXPDj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 11:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754011AbZIXPDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 11:03:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35772 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004AbZIXPDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 11:03:36 -0400
Subject: Re: [PATCH 02/10] writeback: balance_dirty_pages() shall write
 more than dirtied pages
From: Peter Zijlstra <peterz@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, fengguang.wu@intel.com, shaohua.li@intel.com,
       chris.mason@oracle.com, jack@suse.cz
In-Reply-To: <1253803236-20760-3-git-send-email-jens.axboe@oracle.com>
References: <1253803236-20760-1-git-send-email-jens.axboe@oracle.com>
	 <1253803236-20760-3-git-send-email-jens.axboe@oracle.com>
Content-Type: text/plain
Date: Thu, 24 Sep 2009 17:03:34 +0200
Message-Id: <1253804614.18939.35.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-24 at 16:40 +0200, Jens Axboe wrote:
> From: Wu Fengguang <fengguang.wu@intel.com>
> 
> Some filesystem may choose to write much more than ratelimit_pages
> before calling balance_dirty_pages_ratelimited_nr(). So it is safer to
> determine number to write based on real number of dirtied pages.
> 
> Otherwise it is possible that
>   loop {
>     btrfs_file_write():     dirty 1024 pages
>     balance_dirty_pages():  write up to 48 pages (= ratelimit_pages * 1.5)
>   }
> in which the writeback rate cannot keep up with dirty rate, and the
> dirty pages go all the way beyond dirty_thresh.
> 
> The increased write_chunk may make the dirtier more bumpy.
> So filesystems shall be take care not to dirty too much at
> a time (eg. > 4MB) without checking the ratelimit.
> 
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

