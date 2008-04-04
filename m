Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891AbYDDLtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbYDDLtK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 07:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756696AbYDDLsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 07:48:52 -0400
Received: from brick.kernel.dk ([87.55.233.238]:22724 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682AbYDDLsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 07:48:51 -0400
Date: Fri, 4 Apr 2008 13:46:00 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: joern@logfs.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org, Nick Piggin <npiggin@suse.de>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [patch 0/15] LogFS take five
Message-ID: <20080404114600.GD29686@kernel.dk>
References: <20080401181308.512473173@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080401181308.512473173@logfs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01 2008, joern@logfs.org wrote:
> And it is currently reasonably simple to run into a deadlock when
> using logfs on a block device.  The problem appears to be the block
> layer allocating memory for its cache without GFP_NOFS, so that under
> memory pressure logfs writes through block layer may recurse back to
> logfs writes.

So you mean for writes through the page cache, you are seeing pages
allocated with __GFP_FS set?

> Not entirely sure who is to blame for this bug and how to
> solve it.

A good starting point would be doing a stack trace dump in logfs if you
see such back recursion into the fs. A quick guess would be a missing
setting of mapping gfp mask?

-- 
Jens Axboe

