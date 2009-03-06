Return-Path: <linux-kernel-owner+w=401wt.eu-S1756386AbZCFPzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386AbZCFPzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 10:55:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754875AbZCFPzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 10:55:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:35715 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754743AbZCFPzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 10:55:42 -0500
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, npiggin@suse.de,
       akpm@linux-foundation.org
Subject: [GIT PULL] percpu: finer grained locking
Date: Sat,  7 Mar 2009 00:54:39 +0900
Message-Id: <1236354883-25063-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 06 Mar 2009 15:54:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

Please pull from the following git vector.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu

This patchset makes locking in dynamic percpu allocator finer grained
to break deadlock[1] and allow atomic free.

This patchset is on top of the current x86/core/percpu[2] contains the
following patches.

 0001-percpu-replace-pcpu_realloc-with-pcpu_mem_alloc.patch
 0002-percpu-move-chunk-area-map-extension-out-of-area-al.patch
 0003-percpu-move-fully-free-chunk-reclamation-into-a-wor.patch
 0004-percpu-finer-grained-locking-to-break-deadlock-and.patch

0001-0003 prepare for finer grained locking.  0004 implements it.

Diffstat follows.

 mm/percpu.c |  365 ++++++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 245 insertions(+), 120 deletions(-)

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/802384
[2] 6b19b0c2400437a3c10059ede0e59b517092e1bd
