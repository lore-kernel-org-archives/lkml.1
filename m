Return-Path: <linux-kernel-owner+w=401wt.eu-S1752470AbZIICK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbZIICK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 22:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbZIICK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 22:10:28 -0400
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:51440 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751192AbZIICK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 22:10:28 -0400
X-Greylist: delayed 916 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Sep 2009 22:10:27 EDT
Date: Wed, 9 Sep 2009 11:53:59 +1000
From: Dave Chinner <david@fromorbit.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Chris Mason <chris.mason@oracle.com>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz,
       "Theodore Ts'o" <tytso@mit.edu>, Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 8/8] vm: Add an tuning knob for vm.max_writeback_mb
Message-ID: <20090909015359.GC7146@discord.disaster>
References: <1252401791-22463-1-git-send-email-jens.axboe@oracle.com> <1252401791-22463-9-git-send-email-jens.axboe@oracle.com> <4AA633FD.3080006@gmail.com> <1252425983.7746.120.camel@twins> <20090908162936.GA2975@think> <1252428983.7746.140.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252428983.7746.140.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 08, 2009 at 06:56:23PM +0200, Peter Zijlstra wrote:
> On Tue, 2009-09-08 at 12:29 -0400, Chris Mason wrote:
> > Either way, if pdflush or the bdi thread or whoever ends up switching to
> > another file during a big streaming write, the end result is that we
> > fragment.  We may fragment the file (ext4) or we may fragment the
> > writeback (xfs), but the end result isn't good.
> 
> OK, so what we want is for a way to re-enter the whole
> writeback_inodes() path onto the same file, right?

No, that would take use back to the Bad Old Days where one large
file write can starve out the other 10,000 small files that need to
be written. The old writeback code used to end up in this way
because it didn't rotate large files to the back of the dirty inode
queue once wbc->nr_to_write was exhausted. This could cause files
not to be written back for tens of minutes....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
