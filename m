Return-Path: <linux-kernel-owner+w=401wt.eu-S1762958AbZE0PFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762958AbZE0PFM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 11:05:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760177AbZE0PE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 11:04:59 -0400
Received: from brick.kernel.dk ([93.163.65.50]:43462 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729AbZE0PE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 11:04:59 -0400
Date: Wed, 27 May 2009 17:05:00 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Theodore Tso <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads v8
Message-ID: <20090527150459.GL11363@kernel.dk>
References: <1243417312-7444-1-git-send-email-jens.axboe@oracle.com> <20090527144754.GD10842@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527144754.GD10842@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27 2009, Theodore Tso wrote:
> Hi Jens,
> 
> FYI, just for yucks I tried to merge your bdi patches and the ext4
> patch queue to make sure there were no patch conflicts, and started a
> quick regression run.  I got the following soft lockup report when
> running "fsstress -d /mnt/tmp -s 12345 -S -p 20 -n 1000".
> 
> I'll retry the test with your stock writeback-v8 git branch w/o any
> ext4 patches planned the next mere window mainline to see if I get the
> same soft lockup, but I thought I should give you an early heads up.

It looks like it's the writeback patches, from a quick glance. Did it
get stuck, or did it still make progress? Thanks for testing, please let
me know if it triggers with just wb-v8. Can you send me your .config,
too? I'm assuming no special ext4 mount options, right? I used ext4 as
well for testing, using -o barrier=0 for most of the runs.

Irregardless, I'll try this test and poke a bit at it and find out what
the issue is.

-- 
Jens Axboe

