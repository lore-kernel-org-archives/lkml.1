Return-Path: <linux-kernel-owner+w=401wt.eu-S1754355AbYHTC1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355AbYHTC1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 22:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbYHTC1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 22:27:14 -0400
Received: from tau.jukie.net ([216.239.93.128]:55940 "EHLO tau.jukie.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbYHTC1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 22:27:14 -0400
Date: Tue, 19 Aug 2008 22:27:12 -0400
From: Bart Trojanowski <bart@jukie.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: vfat BKL/lock_super regression in v2.6.26-rc3-g8f59342
Message-ID: <20080820022712.GF28029@jukie.net>
References: <20080819220311.GA28029@jukie.net> <alpine.LFD.1.10.0808191505590.3324@nehalem.linux-foundation.org> <20080820001845.GC28029@jukie.net> <alpine.LFD.1.10.0808191729330.3324@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808191748040.3324@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808191748040.3324@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds <torvalds@linux-foundation.org> [080819 20:56]:
> So one thing we could perhaps consider is to make FAT in particular 
> consider "sync" mounts to be about open/close consistency, not about 
> per-write-system-call consistency. So the "close()" wouldn't return until 
> the file is on disk, but we wouldn't force a synchronous rewrite the inode 
> or the file allocation table thousands of times just because the file was 
> big.

I was reading the vfat code, and it turns out that vfat has a "flush"
mount option.  Which is documented in the code (not in the manpage) as:

    struct fat_mount_options {
            ...
            unsigned
            ...
                     flush:1,         /* write things quickly */

Since that was very informative I looked at the usage.  It's used
in fat_file_release() to do almost what you describe.  But it seems to
be a best effort thing.  If my data doesn't hit the disk (or flash) in
HZ/10, then all bets are off.

-Bart

-- 
				WebSig: http://www.jukie.net/~bart/sig/
