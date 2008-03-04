Return-Path: <linux-kernel-owner+w=401wt.eu-S1761272AbYCDDjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761272AbYCDDjm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 22:39:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756849AbYCDDje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 22:39:34 -0500
Received: from mga03.intel.com ([143.182.124.21]:29081 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756475AbYCDDjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 22:39:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,441,1199692800"; 
   d="scan'208";a="214525588"
Subject: early_res and find_e820_area for i386?
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 04 Mar 2008 11:38:03 +0800
Message-Id: <1204601883.4707.96.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 04 Mar 2008 03:36:09.0952 (UTC) FILETIME=[E32E9E00:01C87DA8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Before bootmem allocator is available, kernel needs allocate memory
pages such as page table and some NUMA structures. On x86_64, this is
done by early_res and find_e820_area. On i386, this is done through
using the memory area after kernel itself which is tracked with
init_pg_tables_end.

Is it better to implement early_res and find_e820_area on i386? Can we
trust E820 table on i386?

Or we add an early_alloc, which allocate memory from the memory area
after kernel itself and check the early_res areas and E820 table too.

BTW: Why not merge e820_32.c and e820_64.c? At least part of them.

Best Regards,
Huang Ying

