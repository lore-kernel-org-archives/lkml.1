Return-Path: <linux-kernel-owner+w=401wt.eu-S1755049AbYLOKFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbYLOKFz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 05:05:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbYLOKFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 05:05:40 -0500
Received: from one.firstfloor.org ([213.235.205.2]:57695 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881AbYLOKFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 05:05:40 -0500
Date: Mon, 15 Dec 2008 11:17:39 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: andi@firstfloor.org, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mmotm 1/5] nilfs2: fix problems of memory allocation in ioctl
Message-ID: <20081215101739.GO25779@one.firstfloor.org>
References: <1229059021-9538-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp> <1229059021-9538-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp> <871vwdcxo1.fsf@basil.nowhere.org> <20081213.034808.104867584.ryusuke@osrg.net> <20081212202411.GK25779@one.firstfloor.org> <20081213.172915.31069043.ryusuke@osrg.net> <20081214.210839.09550698.ryusuke@osrg.net> <20081214151327.GM25779@one.firstfloor.org> <20081215.155840.105124170.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081215.155840.105124170.ryusuke@osrg.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2008 at 03:58:40PM +0900, Ryusuke Konishi wrote:
> On Sun, 14 Dec 2008 16:13:27 +0100, Andi Kleen <andi@firstfloor.org> wrote:
> > > -#define KMALLOC_SIZE_MIN	4096	/* 4KB */
> > > -#define KMALLOC_SIZE_MAX	131072	/* 128 KB */
> > > +#define NILFS_IOCTL_KMALLOC_SIZE	8192	/* 8KB */
> > 
> > Better would be if you could go to PAGE_SIZE. order 0 allocations
> > are typically the fastest / least likely to stall.
> > 
> > Also in this case it's a good idea to use __get_free_pages()
> > directly, kmalloc tends to be become less efficient at larger
> > sizes.
> 
> Thanks again.  I've rewritten the patch to use __get_free_pages().

Thanks looks good now.

-Andi
