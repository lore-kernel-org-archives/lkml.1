Return-Path: <linux-kernel-owner+w=401wt.eu-S1756701AbZGGJR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701AbZGGJR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 05:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120AbZGGJRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 05:17:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41371 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753274AbZGGJRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 05:17:19 -0400
Date: Tue, 7 Jul 2009 11:17:22 +0200
From: Nick Piggin <npiggin@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [rfc][patch 3/3] fs: convert ext2,tmpfs to new truncate
Message-ID: <20090707091722.GZ2714@wotan.suse.de>
References: <20090706165438.GQ2714@wotan.suse.de> <20090706165629.GS2714@wotan.suse.de> <20090706172838.GC26042@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090706172838.GC26042@infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 06, 2009 at 01:28:38PM -0400, Christoph Hellwig wrote:
> On Mon, Jul 06, 2009 at 06:56:29PM +0200, Nick Piggin wrote:
> > 
> > Convert filemap_xip.c, buffer.c, and some filesystems to the new truncate
> > convention. Converting generic helpers is using some ugly code (testing
> > for i_op->ftruncate) to distinguish new and old callers... better
> > alternative might be just define a new function for these guys.
> 
> Splitting generic preparations, ext2 and shmem into separate patch would
> be a tad cleaner I think.

I actually reworked this so callers of those functions should do the
i_size update and truncate_pagecache (which gives more flexibility
anyway). And so no further changes required there.

