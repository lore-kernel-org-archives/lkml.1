Return-Path: <linux-kernel-owner+w=401wt.eu-S1759163AbYAJIpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759163AbYAJIpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 03:45:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759158AbYAJIpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 03:45:01 -0500
Received: from brick.kernel.dk ([87.55.233.238]:24994 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754170AbYAJIpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 03:45:00 -0500
Date: Thu, 10 Jan 2008 09:44:57 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org,
       chris.mason@oracle.com, linux-fsdevel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH][RFC] fast file mapping for loop
Message-ID: <20080110084457.GT6258@kernel.dk>
References: <20080109085231.GE6650@kernel.dk> <200801101242.25671.nickpiggin@yahoo.com.au> <20080110083753.GB10745@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080110083753.GB10745@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10 2008, Christoph Hellwig wrote:
> > > loop maintains a prio tree of known 
> > > extents in the file (populated lazily on demand, as needed).
> > 
> > Just a quick question (I haven't looked closely at the code): how come
> > you are using a prio tree for extents? I don't think they could be
> > overlapping?
> 
> IMHO this shouldn't be done in the loop driver anyway.  Filesystems have
> their own effricient extent lookup trees (well, at least xfs and btrfs
> do), and we should leverage that instead of reinventing it.

Completely agree, it's just needed right now for this solution since all
we have is a crappy bmap() interface to get at those mappings.

-- 
Jens Axboe

