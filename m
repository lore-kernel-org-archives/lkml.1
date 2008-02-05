Return-Path: <linux-kernel-owner+w=401wt.eu-S1758997AbYBEBSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758997AbYBEBSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 20:18:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758886AbYBEBSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 20:18:10 -0500
Received: from mga11.intel.com ([192.55.52.93]:46294 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758868AbYBEBSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 20:18:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,304,1199692800"; 
   d="scan'208";a="295806554"
Date: Mon, 4 Feb 2008 17:13:57 -0800
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: tglx@linutronix.de, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, arjan@linux.intel.com
Subject: issue with patch "x86: no CPA on iounmap"
Message-ID: <20080205011357.GA14712@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is wrt to x86 git commit f56d005d30342a45d8af2b75ecccc82200f09600
	"x86: no CPA on iounmap"

This can use performance issue. When a GART driver unmaps a RAM page,
which was mapped as UC, this commit will still retain UC attribute
on the kernel identity mapping. This can cause mysterious performance issue
if this freed page gets used by kernel later.

For now we should change the attribute during iounmap and in future PAT
infrastructure will have necessary hooks to avoid the aliasing issues.

thanks,
suresh
