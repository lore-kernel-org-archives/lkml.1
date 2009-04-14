Return-Path: <linux-kernel-owner+w=401wt.eu-S1759598AbZDNSf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759598AbZDNSf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 14:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759369AbZDNSd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 14:33:56 -0400
Received: from THUNK.ORG ([69.25.196.29]:56652 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759358AbZDNSdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 14:33:55 -0400
Date: Tue, 14 Apr 2009 14:33:51 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>, Neil Brown <neilb@suse.de>,
       linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Kleikamp <shaggy@austin.ibm.com>, xfs-masters@oss.sgi.com
Subject: Re: [PATCH 0/6] Handle bio_alloc failure
Message-ID: <20090414183351.GK955@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jens Axboe <jens.axboe@oracle.com>,
	Nikanth Karthikesan <knikanth@suse.de>, Neil Brown <neilb@suse.de>,
	linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Kleikamp <shaggy@austin.ibm.com>, xfs-masters@oss.sgi.com
References: <200904141636.26557.knikanth@novell.com> <20090414111838.GG5178@kernel.dk> <200904141711.20378.knikanth@suse.de> <20090414181632.GI955@mit.edu> <20090414182049.GI5178@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090414182049.GI5178@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 08:20:49PM +0200, Jens Axboe wrote:
> 
> It's a bio_alloc() guarantee, it uses a mempool backing. And if you use
> a mempool backing, any allocation that can wait will always be
> satisfied.
> 

Am I missing something?  I don't see anything in
include/linux/mempool.h or mm/mempool.c, or in block/blk-core.c or
include/linux/bio.h which documents that GFP_WAIT implies that
bio_alloc() will always succeed.   

My concern is that at some point in the future, someone either in the
block device layer or in mm/mempool.c will consider this an
implementation detail, and all of sudden calls to bio_alloc() with
GFP_WAIT will start failing and the resulting hilarty which ensues
won't be easily predicted by the developer making this change.

Regards,

					- Ted
