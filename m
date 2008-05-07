Return-Path: <linux-kernel-owner+w=401wt.eu-S1757697AbYEGFGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757697AbYEGFGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 01:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbYEGFGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 01:06:23 -0400
Received: from mga12.intel.com ([143.182.124.36]:1400 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751517AbYEGFGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 01:06:22 -0400
X-Greylist: delayed 575 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 May 2008 01:06:22 EDT
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,446,1204531200"; 
   d="scan'208";a="243096574"
Subject: sysbench+mysql(oltp, readonly) 30% regression with 2.6.26-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 07 May 2008 12:55:48 +0800
Message-Id: <1210136148.3453.59.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿Comparing with kernel 2.6.25, sysbench+mysql(oltp, readonly) has many
regression with 2.6.26-rc1.

1) 8-core stoakley: 28%;
2) 16-core tigerton: 20%;
3) Itanium Montvale: 50%.

Bisect located below patch.

8f1bc385cfbab474db6c27b5af1e439614f3025c is first bad commit
commit 8f1bc385cfbab474db6c27b5af1e439614f3025c
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Sat Apr 19 19:45:00 2008 +0200

    sched: fair: weight calculations
    
    In order to level the hierarchy, we need to calculate load based on the
    root view. That is, each task's load is in the same unit.



After I manually reverted the patch against 2.6.26-rc1 while fixing a couple of
conflictions/errors, sysbench oltp regression became less than 3% on 8-core
stoakley.

-yanmin


