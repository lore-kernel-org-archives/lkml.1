Return-Path: <linux-kernel-owner+w=401wt.eu-S1761439AbYEFCH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761439AbYEFCH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 22:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753146AbYEFCHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 22:07:15 -0400
Received: from mga10.intel.com ([192.55.52.92]:8010 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752309AbYEFCHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 22:07:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,440,1204531200"; 
   d="scan'208";a="324853254"
Subject: volanoMark regression with kernel 2.6.26-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 06 May 2008 10:06:30 +0800
Message-Id: <1210039590.3453.18.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comparing with 2.6.25, volanoMark has big regression with kernel 2.6.26-rc1.
It's about 50% on my 8-core stoakley, 16-core tigerton, and Itanium Montecito.

With bisect, I located below patch.

18d95a2832c1392a2d63227a7a6d433cb9f2037e is first bad commit
commit 18d95a2832c1392a2d63227a7a6d433cb9f2037e
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Sat Apr 19 19:45:00 2008 +0200

    sched: fair-group: SMP-nice for group scheduling
    
    Implement SMP nice support for the full group hierarchy.

If I reverse the patch with resolving some conflictions, volanoMark result could
be restored completely.

﻿
AIM7 (use tmpfs) also has ﻿more than 40% on my 8-core stoakley, 16-core tigerton,
and Itanium Montecito, but I verified that aim7 regression isn't caused by above
patch. I am doing new bisect to check aim7 now.

-yanmin


