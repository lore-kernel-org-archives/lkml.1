Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175AbYITLF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbYITLF0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 07:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbYITLFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 07:05:13 -0400
Received: from lazybastard.de ([212.112.238.170]:43083 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbYITLFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 07:05:11 -0400
Date: Sat, 20 Sep 2008 13:04:59 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, kihara.seiji@lab.ntt.co.jp,
       amagai.yoshiji@lab.ntt.co.jp
Subject: Re: [PATCH 25/27] nilfs2: block cache for garbage collection
Message-ID: <20080920110459.GB9418@logfs.org>
References: <20080917144146.GD8750@logfs.org> <20080918.040945.32654226.ryusuke@osrg.net> <20080917224953.GB14644@logfs.org> <20080920.194358.07565122.ryusuke@osrg.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080920.194358.07565122.ryusuke@osrg.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 September 2008 19:43:58 +0900, Ryusuke Konishi wrote:
> 
> > But that would be inefficient in several cases.  When
> > GC'ing data that is dirty in the caches, you move the old stale data
> > during GC and write the new data soon after.  And you always flush the
> > caches after GC, even if your machine has no better use for the memory.
> 
> As for as NILFS2, the dirty blocks and the blocks to be moved by GC
> never overlap because the dirty blocks make a new generation.
> So, they rather must be written individually.
> 
> Though we can reuse pages in the GC cache, the effect of this
> optimization may be much lower than usual LFSes because most of
> blocks in the pages may not belong to the latest generation.

Yet again I've tried to apply techniques that simply don't work with
checkpoints in the equation.

> NILFS2 needs explication than usual file systems; it needs time
> perspective as well as it is an LFS. :)

At least if you take me as a standard, I think you have proven that
point rather well. :)

Jörn

-- 
Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it.
-- Brian W. Kernighan
