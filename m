Return-Path: <linux-kernel-owner+w=401wt.eu-S1756602AbZDPNUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602AbZDPNUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 09:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756496AbZDPNTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 09:19:54 -0400
Received: from mtoichi11.ns.itscom.net ([219.110.2.181]:41560 "EHLO
	mtoichi11.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919AbZDPNTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 09:19:53 -0400
From: hooanon05@yahoo.co.jp
To: zohar@us.ibm.com
cc: linux-kernel@vger.kernel.org
Subject: IMA and fs
Date: Thu, 16 Apr 2009 22:19:45 +0900
Message-ID: <15909.1239887985@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I have found (at least) two issues about IMA.

1.
Calling stack
- kmem_cache_alloc(iint_cache, GFP_KERNEL)
- ima_inode_alloc()
- inode_init_always()
- xfs_iget_cache_hit()
- xfs_iget()

xfs_iget() holds spinlock before xfs_iget_cache_hit(), and
ima_inode_alloc() cannot use GFP_KERNEL.

2.
ima_path_check() seems to be necessary before every opening a file.
In 2.6.30-rc1, IMA produces lots of messages and stack trace when NFSD
opens a file. 
Does nfsd_open() need to to call ima_path_check()?


J. R. Okajima
