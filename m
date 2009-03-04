Return-Path: <linux-kernel-owner+w=401wt.eu-S1756612AbZCDSwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612AbZCDSwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 13:52:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755102AbZCDSwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 13:52:03 -0500
Received: from mx2.redhat.com ([66.187.237.31]:39279 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294AbZCDSwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 13:52:01 -0500
Date: Wed, 4 Mar 2009 13:50:53 -0500
From: Josef Bacik <josef@redhat.com>
To: Hugo Mills <hugo-lkml@carfax.org.uk>, linux-btrfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Subject: Re: Entirely unexpected ENOSPC?
Message-ID: <20090304185053.GI5446@unused.rdu.redhat.com>
References: <20090304180619.GA3282@selene>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090304180619.GA3282@selene>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 04, 2009 at 06:06:19PM +0000, Hugo Mills wrote:
>    Last night, this event jammed up a good chunk of my server:
> 
> Mar  4 01:51:36 vlad kernel: btrfs searching for 1716224 bytes, num_bytes 1716224, loop 2, allowed_alloc 1
> Mar  4 01:51:36 vlad kernel: btrfs searching for 860160 bytes, num_bytes 860160, loop 2, allowed_alloc 1
> [lots of this...]
> Mar  4 01:55:52 vlad kernel: btrfs searching for 4096 bytes, num_bytes 4096, loop 2, allowed_alloc 1
> Mar  4 01:55:52 vlad kernel: btrfs allocation failed flags 1, wanted 4096
> Mar  4 01:55:52 vlad kernel: space_info has 0 free, is full
> Mar  4 01:55:52 vlad kernel: block group 12582912 has 8388608 bytes, 8388608 used 0 pinned 0 reserved
> Mar  4 01:55:52 vlad kernel: 0 blocks of free space at or bigger than bytes is
> Mar  4 01:55:52 vlad kernel: block group 1103101952 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
> Mar  4 01:55:52 vlad kernel: 0 blocks of free space at or bigger than bytes is
> [30 more lines of this]

So yeah thats expected, you ran out of space.  The key thing is this

Mar  4 01:55:52 vlad kernel: space_info has 0 free, is full

If space_info has 0 free and is full, then there is no space to allocate for it
and its completely used.  I'd recommend switching to the -rc7 kernel since that
has things in place to keep this from happening as often.  Thanks,

Josef
