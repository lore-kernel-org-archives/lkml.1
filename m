Return-Path: <linux-kernel-owner+w=401wt.eu-S1754527AbZIPBvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbZIPBvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 21:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753932AbZIPBvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 21:51:38 -0400
Received: from mga14.intel.com ([143.182.124.37]:51194 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243AbZIPBvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 21:51:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,394,1249282800"; 
   d="scan'208";a="188088266"
Message-Id: <20090916013939.656308742@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 16 Sep 2009 09:39:39 +0800
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
Subject: [PATCH 0/3] /proc/kmem fixes and hwpoison bits v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew and Kame,

Here are the 3 updated bug fix/cleanup patches for kmem.  Comments are welcome.

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

