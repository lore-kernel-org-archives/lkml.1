Return-Path: <linux-kernel-owner+w=401wt.eu-S1752414AbZJJFst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbZJJFst (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 01:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbZJJFss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 01:48:48 -0400
Received: from mga06.intel.com ([134.134.136.21]:51711 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751948AbZJJFss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 01:48:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,536,1249282800"; 
   d="scan'208";a="456178367"
Subject: fio rand read/write regression with 2.6.32-rc3
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 10 Oct 2009 13:48:44 +0800
Message-Id: <1255153724.25078.68.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comparing with 2.6.23-rc1's result, fio rand read write has regression
on my 2*4 core stoakley machine (8GB memory) with a JBOD of 12 disks.

Every disk has 8 1-GB files. Start 8 sub-processes per disk and every
process random chooses a file on the disk to do 36 times of file read or
write on the file and then choose another file.


fio_mmap_rand_read_4k regresion is about 35%.
Bisect down to patch:
1d2235152dc745c6d94bedb550fea84cffdbf768 is first bad commit
commit 1d2235152dc745c6d94bedb550fea84cffdbf768
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Fri Oct 2 19:27:04 2009 +0200

    cfq-iosched: add a knob for desktop interactiveness


After I revert the patch against 2.6.23-rc3, fio_mmap_rand_read_4k regression
disappears.

fio_mmap_randrw_4k has less than 20% regression and reverting the patch
could restore performance.

On another stoakley machine with another JBOD, we see the similiar regression.

ffsb rand read/write has a bigger regression and reverting the patch
could restore performance.

Yanmin


