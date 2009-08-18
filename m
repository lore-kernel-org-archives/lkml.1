Return-Path: <linux-kernel-owner+w=401wt.eu-S1755119AbZHRIfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119AbZHRIfG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 04:35:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754992AbZHRIfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 04:35:04 -0400
Received: from brick.kernel.dk ([93.163.65.50]:34356 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753707AbZHRIfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 04:35:02 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: zach.brown@oracle.com, hch@infradead.org
Subject: [PATCH 0/4] Page based O_DIRECT v2
Date: Tue, 18 Aug 2009 10:34:57 +0200
Message-Id: <1250584501-31140-1-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.53.g3f55e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Updated patchset for page based O_DIRECT. I didn't include the
loop bits this time, lets focus on getting these core bits into
shape and then loop is easily patchable on top of this.

Changes since last post:

- Changed do_dio() to generic_file_direct_IO() as per Christophs
  suggestion.
- Split the first patch into two parts. One simply adds dio_args
  and maintains the current code, the next has the functional change
  but without changing file systems (except NFS).
- Add ->rw to dio_args (Christoph).
- A locking fixup. Not really related, but should be fixed up anyways.

There are at least two pending things to work on:

1) NFS is still broken, I get a crash in freeing some data that
   is not related to the pages. Will debug this.
2) As Christoph suggested, we need some way to wait for a dio
   when all segments are submitted. Currently it waits for each
   segment. Not sure how best to solve this issue, will think a
   bit more about this. Basically we need to pass down the wait
   list to the generic_file_direct_IO() and have that do the
   queue kick and wait.

-- 
Jens Axboe

