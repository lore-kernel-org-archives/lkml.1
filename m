Return-Path: <linux-kernel-owner+w=401wt.eu-S1756817AbYD2H1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817AbYD2H1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 03:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757030AbYD2HZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 03:25:52 -0400
Received: from brick.kernel.dk ([87.55.233.238]:17210 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753995AbYD2HZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 03:25:44 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, npiggin@suse.de, linux-arch@vger.kernel.org,
       jeremy@goop.org, mingo@elte.hu, paulmck@linux.vnet.ibm.com
Subject: [PATCH 0/10] Add generic helpers for arch IPI function calls #3
Date: Tue, 29 Apr 2008 09:26:20 +0200
Message-Id: <1209453990-7735-1-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.5.1.57.g5909c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a repost of the generic-ipi block git branch. It contains
generic helpers for issuing and handling IPI function calls. It
improves smp_call_function_single() so that it is now a scalable
interface that doesn't rely on call_lock and it also greatly
speeds up smp_call_function(). Microbenchmarks show that it is about
30% faster on call throughput on a simple 2-way SMP system. Benefits
should be much higher on bigger systems.

Changes since last post:

- Address Andrew's review comments
- Address Paul's RCU comments. Hopefully everything is covered now,
  I'd much appreciate a second look at this code Paul!
- Drop s390 support, as it currently relies on smp_call_function()
  not returning before other CPUs are ready (or have) called the passed
  in function.
- Address the x86/xen comments from Jeremy, I hope xen works as expected
  now.
- Address the review comments from Peter.
- Various other little things and improvements.

-- 
Jens Axboe



