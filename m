Return-Path: <linux-kernel-owner+w=401wt.eu-S1756686AbYFXIGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686AbYFXIGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 04:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200AbYFXIGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 04:06:01 -0400
Received: from brick.kernel.dk ([87.55.233.238]:23909 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265AbYFXIF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 04:05:59 -0400
Date: Tue, 24 Jun 2008 10:05:57 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, torvalds@linux-foundation.org
Subject: Re: [rfc patch 4/4] splice: use do_generic_file_read()
Message-ID: <20080624080557.GK20851@kernel.dk>
References: <20080621154607.154640724@szeredi.hu> <20080621154727.808329488@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080621154727.808329488@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21 2008, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> __generic_file_splice_read() duplicates a lot of stuff common with the
> generic page cache reading.  So reuse that code instead to simplify
> the page cache splice code.
> 
> This also fixes some corner cases which weren't properly handled in
> the splice code because of complexity issues.  In particular it fixes
> a problem when the filesystem (e.g. fuse) invalidates pages during the
> splice operation.
> 
> There might be some slight fall in performance due to the removal of
> the gang lookup for pages.  However I'm not sure if this is
> significant enough to warrant the extra complication.

This makes everything sync, it's a no go. Why don't we look into fixing
the invalidate problem that fuse sees (can you elaborate on that?)?

I tried to do a quick performance test with your patches for comparison
in the cached case, but it crashes immediately in spd_release_page()


-- 
Jens Axboe

