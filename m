Return-Path: <linux-kernel-owner+w=401wt.eu-S1758283AbZABQiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283AbZABQiW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 11:38:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756542AbZABQiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 11:38:10 -0500
Received: from sh.osrg.net ([192.16.179.4]:49785 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754658AbZABQiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 11:38:09 -0500
Date: Sat, 03 Jan 2009 01:37:55 +0900 (JST)
Message-Id: <20090103.013755.42849152.ryusuke@osrg.net>
To: Chris Mason <chris.mason@oracle.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: Btrfs for mainline
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <1230765549.7538.8.camel@think.oraclecorp.com>
References: <1230722935.4680.5.camel@think.oraclecorp.com>
	<20081231104533.abfb1cf9.akpm@linux-foundation.org>
	<1230765549.7538.8.camel@think.oraclecorp.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Wed, 31 Dec 2008 18:19:09 -0500, Chris Mason <chris.mason@oracle.com> wrote:
> 
> This has only btrfs as a module and would be the fastest way to see
> the .c files.  btrfs doesn't have any changes outside of fs/Makefile and
> fs/Kconfig

I found some overlapping (or cloned) functions in
btrfs-unstable.git/fs/btrfs, for example:

 - Declarations to apply hardware crc32c in fs/btrfs/crc32c.h:
   The same code is found in arch/x86/crypto/crc32c-intel.c

 - btrfs_wait_on_page_writeback_range() and btrfs_fdatawrite_range():
   These are clones of wait_on_page_writeback_range() and
   __filemap_fdatawrite_range() respectively, and can be removed if they
   are just exported.

 - Copies of add_to_page_cache_lru() found in compression.c and extent_io.c
   (can be replaced if it's exported)

How about including patches to resolve these in the btrfs kernel tree
(or patchset to be posted) ?

In addition, there seem to be well-separated reusable routines such as
async-thread (enhanced workqueue) and extent_map.  Do you intend to
move these into lib/ or so?

I also tried scripts/checkpatch.pl against btrfs, and it has detected
45 ERRORs and 93 WARNINGs.  I think it's a good opportunity to clean
up these violations.


With regards,
Ryusuke Konishi
