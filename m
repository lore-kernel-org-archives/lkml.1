Return-Path: <linux-kernel-owner+w=401wt.eu-S1764341AbXKNURi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764341AbXKNURi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 15:17:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756648AbXKNUQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 15:16:54 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33409 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754101AbXKNUQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 15:16:51 -0500
Message-Id: <20071114200136.009242000@chello.nl>
User-Agent: quilt/0.45-1
Date: Wed, 14 Nov 2007 21:01:36 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Nick Piggin <npiggin@suse.de>, Hugh Dickins <hugh@veritas.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 0/3] mmap vs NFS
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently there is an AB-BA deadlock in NFS mmap.

nfs_file_mmap() can take i_mutex, while holding mmap_sem, whereas the regular
locking order is the other way around.

This patch-set attempts to solve this issue.

