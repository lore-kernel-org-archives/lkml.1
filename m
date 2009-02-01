Return-Path: <linux-kernel-owner+w=401wt.eu-S1752701AbZBAHav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbZBAHav (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 02:30:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbZBAHan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 02:30:43 -0500
Received: from mga12.intel.com ([143.182.124.36]:23021 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751281AbZBAHam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 02:30:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,359,1231142400"; 
   d="scan'208";a="105813539"
Subject: hackbench [pthread mode] regression with 2.6.29-rc3
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Sun, 01 Feb 2009 15:30:26 +0800
Message-Id: <1233473426.2604.13.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comparing with 2.6.29-rc2's result, hackbench [pthread mode] result is increased about
50%~100% with 2.6.29-rc3 on my 4 qual-core process tigerton machine and 4 qual-core
Montvale Itanium mahchine. The smaller result, the better performance.
﻿
Command to run hackbench:
#./hackbench 100 thread 2000

Bisect located below patch.
commit 490dea45d00f01847ebebd007685d564aaf2cd98
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Mon Nov 24 17:06:57 2008 +0100

    itimers: remove the per-cpu-ish-ness

    Either we bounce once cacheline per cpu per tick, yielding n^2 bounces
    or we just bounce a single..

    Also, using per-cpu allocations for the thread-groups complicates the
    per-cpu allocator in that its currently aimed to be a fixed sized
    allocator and the only possible extention to that would be vmap based,
    which is seriously constrained on 32 bit archs.


After above patch is reverted, hackbench result is restored.

yanmin


