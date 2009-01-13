Return-Path: <linux-kernel-owner+w=401wt.eu-S1759404AbZAMI53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759404AbZAMI53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 03:57:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755052AbZAMI5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 03:57:19 -0500
Received: from mga05.intel.com ([192.55.52.89]:41211 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752527AbZAMI5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 03:57:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,258,1231142400"; 
   d="scan'208";a="421907680"
Subject: Performance regression of specjbb2005/aim7 with 2.6.29-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>, ming.m.lin@intel.com,
       Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 13 Jan 2009 16:57:16 +0800
Message-Id: <1231837036.11429.27.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comparing with 2.6.28's results, specjbb2005 has about 7% regression with 2.6.29-rc1
on my a couple of x86_64 machines. aim7 has about 1.7% regression.

Ming did a quick bisect with aim7 and located below patch.

﻿commit 0a582440ff546e2c6610d1acec325e91b4efd313
Author: Mike Galbraith <efault@gmx.de>
Date:   Fri Jan 2 12:16:42 2009 +0100

    sched: fix sched_slice()
    
    Impact: fix bad-interactivity buglet
    
    Fix sched_slice() to emit a sane result whether a task is currently
    enqueued or not.
    
    Signed-off-by: Mike Galbraith <efault@gmx.de>
    Tested-by: Jayson King <dev@jaysonking.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>


After we revert the patch, aim7 regression disappeared. specjbb2005 regression becomes
less than 1.5% on 8-core stokley and disappears on 16-core tigerton. I don't know what
causes the last 1.5% regression.

As tbench has about 5% improvement and oltp(mysql+sysbench) has 5% improvement, we also tested
to make sure such improvement isn't related to above patch. volanoMark's improvement is also not
related to the patch. So it seems safe to revert it.

yanmin



