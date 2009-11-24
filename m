Return-Path: <linux-kernel-owner+w=401wt.eu-S933804AbZKXSBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933804AbZKXSBW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 13:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933737AbZKXSBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 13:01:20 -0500
Received: from daytona.panasas.com ([67.152.220.89]:4489 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933760AbZKXSBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 13:01:19 -0500
X-Greylist: delayed 849 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Nov 2009 13:01:18 EST
Message-ID: <4B0C1EB7.50508@panasas.com>
Date: Tue, 24 Nov 2009 19:58:15 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090924 Remi/fc10 Thunderbird/3.0b4
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@citi.umich.edu>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-parisc <linux-parisc@vger.kernel.org>,
       sparclinux <sparclinux@vger.kernel.org>,
       linux-s390 <linux-s390@vger.kernel.org>,
       NFS list <linux-nfs@vger.kernel.org>,
       pNFS Mailing List <pnfs@linux-nfs.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCHSET 0-5] remove unneeded nfsd #includes
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Nov 2009 17:58:18.0770 (UTC) FILETIME=[B4345720:01CA6D2F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some arch files had unneeded #includes directives from linux/nfsd/*.
Some vfs files had unneeded #includes directives from linux/nfsd/*.

In an effort to move some of the now public nfsd headers to the source
directory, submitted a cleanup.

I have cross compiled sparc64 and s390, parsic needs testing. Please ARCH
people sends ACKs, or take these patches through your trees.

patches:
[PATCH 1/5] parsic: remove unused nfsd #includes
	Some kind soul, please compile with this patch? compile
	is all that's needed.

[PATCH 2/5] sparc: remove unused nfsd #includes
[PATCH 3/5] s390: remove unused nfsd #includes
	These two were cross compiled. Should we submit them through
	nfsd tree or the ARCH trees?

[PATCH 4/5] vfs: nfsctl.c unused nfsd #includes
[PATCH 5/5] lockd: Remove unused nfsd headers #includes
	Can these patches go through the nfsd tree?
	Who's ACKs should we collect? Andrew?

Bruce Hi
With this set applied, the only nfsd files used publicly are:
	const.h	export.h nfsfh.h stats.h syscall.h

These files can be moved to source folder:
	cache.h  debug.h  nfsd.h  state.h xdr3.h  xdr4.h  xdr.h

Why is debug.h exported from Kernel? (include/linux/nfsd/Kbuild)

So just to see how this move might look like see last patch:
[RFC] nfsd: Move private headers to source directory
	This patch was compiled, as well, on x86(32/64), sparc64, s390

Thanks
Boaz
