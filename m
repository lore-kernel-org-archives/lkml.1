Return-Path: <linux-kernel-owner+w=401wt.eu-S1752436AbXKIJtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436AbXKIJtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 04:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbXKIJtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 04:49:08 -0500
Received: from mga05.intel.com ([192.55.52.89]:2083 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751501AbXKIJtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 04:49:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,394,1188802800"; 
   d="scan'208";a="375883945"
Subject: iozone write 50% regression in kernel 2.6.24-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: a.p.zijlstra@chello.nl
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=utf-8
Date: Fri, 09 Nov 2007 17:47:52 +0800
Message-Id: <1194601672.20251.60.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Comparing with 2.6.23, iozone sequential write/rewrite (512M) has 50% regression
in kernel 2.6.24-rc1. 2.6.24-rc2 has the same regression.

My machine has 8 processor cores and 8GB memory.

By bisect, I located patch
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=04fbfdc14e5f48463820d6b9807daa5e9c92c51f.


Another behavior: with kernel 2.6.23, if I run iozone for many times after rebooting machine,
the result looks stable. But with 2.6.24-rc1, the first run of iozone got a very small result and
following run has 4Xorig_result.

What I reported is the regression of 2nd/3rd run, because first run has bigger regression.

I also tried to change /proc/sys/vm/dirty_ratio,dirty_backgroud_ratio and didn't get improvement.

-yanmin
