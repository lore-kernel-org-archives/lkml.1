Return-Path: <linux-kernel-owner+w=401wt.eu-S1760293AbYHDGm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760293AbYHDGm5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 02:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755484AbYHDGmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 02:42:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:39293 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755463AbYHDGms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 02:42:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,303,1215414000"; 
   d="scan'208";a="425654888"
Subject: [patch 0/2] reduce agpgart memory allocation time
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: airlied@linux.ie, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 14:51:17 +0800
Message-Id: <1217832677.21811.7.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

agpgart memory allocation is quite expensive. For each page agpgart
allocated, it changes the page to uc and as result flush tlb/cache for
the page. In my test, Intel Xorg driver takes about 0.2s for a 32M 3D
fb, and the total time for memory allocation is about 0.33s when intel
xorg driver initializes. Below patches fix the gap. It can reduce the
time to 0.03s, so xserver can boot 0.3s faster.

Thanks,
Shaohua

