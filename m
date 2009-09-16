Return-Path: <linux-kernel-owner+w=401wt.eu-S1753604AbZIPDHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604AbZIPDHi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 23:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbZIPDHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 23:07:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:7197 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbZIPDHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 23:07:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,394,1249282800"; 
   d="scan'208";a="188105368"
Message-Id: <20090916030009.585103525@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 16 Sep 2009 11:00:09 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Christoph Lameter <cl@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Tejun Heo <tj@kernel.org>
CC: Nick Piggin <npiggin@suse.de>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Subject: [PATCH 0/4] /proc/kmem fixes and hwpoison bits v3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are 2 bug fixes and also hwpoison checks for /dev/mem and /dev/kmem.
The bug fixes are intended for this merge window.

Changes since v2:
- remove the prototype change and make the bug fix simple
- add hwpoison checks for /dev/mem (this is in fact an old patch for me)

Changes since v1:
- change vread()/vwrite() prototype (proposed by Kame)
- include Kame's is_vmalloc_or_module_addr() check and use Hugh's -ENXIO.
- I decided not to use __GFP_ZERO, since the buf will be reused in the loop,
  so it would be better for vread to zero-fill it each time.
- removed the hwpoison checks for vmalloc pages. It seems that vread/vwrite
  could be simplified to handle one single page, and the hwpoison bits can be
  considered after that.

Thanks,
Fengguang
--

