Return-Path: <linux-kernel-owner+w=401wt.eu-S1762304AbYETIK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762304AbYETIK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 04:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757733AbYETIKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 04:10:14 -0400
Received: from mga10.intel.com ([192.55.52.92]:37300 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756426AbYETIKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 04:10:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,514,1204531200"; 
   d="scan'208";a="330218816"
Subject: hackbench regression with 2.6.26-rc2 on tulsa machine
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 20 May 2008 16:09:06 +0800
Message-Id: <1211270946.3177.236.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comparing with 2.6.26-rc1, hackbench has about 30% regression with 2.6.26-rc2 on my tulsa machine
which is a netburst architecure hyper-threading x86_64.

Command line to test: #hackbench 100 process 2000

With ﻿2.6.26-rc1, it takes 30 seconds. But with 2.6.26-rc2/rc3, it takes 40 seconds.

Bisect located below patch:
46151122e0a2e80e5a6b2889f595e371fe2b600d is first bad commit
commit 46151122e0a2e80e5a6b2889f595e371fe2b600d
Author: Mike Galbraith <efault@gmx.de>
Date:   Thu May 8 17:00:42 2008 +0200

    sched: fix weight calculations
    
    The conversion between virtual and real time is as follows:
    
      dvt = rw/w * dt <=> dt = w/rw * dvt
    
    Since we want the fair sleeper granularity to be in real time, we actually
    need to do:
    
      dvt = - rw/w * l



The bisect steps look stable.

On my core architecure machines(stoakley and tigerton), I do see improvement instead of regression,
like result from 31 seconds down to 28 seconds.

I'm not sure if hyper-threading need more cares in this situation.

-yanmin


