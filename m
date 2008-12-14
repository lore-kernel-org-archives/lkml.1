Return-Path: <linux-kernel-owner+w=401wt.eu-S1754399AbYLNPBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399AbYLNPBk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 10:01:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753124AbYLNPB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 10:01:29 -0500
Received: from one.firstfloor.org ([213.235.205.2]:33491 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbYLNPB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 10:01:29 -0500
Date: Sun, 14 Dec 2008 16:13:27 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: akpm@linux-foundation.org, andi@firstfloor.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mmotm 1/5] nilfs2: fix problems of memory allocation in ioctl
Message-ID: <20081214151327.GM25779@one.firstfloor.org>
References: <1229059021-9538-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp> <1229059021-9538-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp> <871vwdcxo1.fsf@basil.nowhere.org> <20081213.034808.104867584.ryusuke@osrg.net> <20081212202411.GK25779@one.firstfloor.org> <20081213.172915.31069043.ryusuke@osrg.net> <20081214.210839.09550698.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081214.210839.09550698.ryusuke@osrg.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -#define KMALLOC_SIZE_MIN	4096	/* 4KB */
> -#define KMALLOC_SIZE_MAX	131072	/* 128 KB */
> +#define NILFS_IOCTL_KMALLOC_SIZE	8192	/* 8KB */

Better would be if you could go to PAGE_SIZE. order 0 allocations
are typically the fastest / least likely to stall.

Also in this case it's a good idea to use __get_free_pages()
directly, kmalloc tends to be become less efficient at larger
sizes.

-Andi
