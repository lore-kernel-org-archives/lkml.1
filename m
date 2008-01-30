Return-Path: <linux-kernel-owner+w=401wt.eu-S1759386AbYA3Jgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759386AbYA3Jgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 04:36:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759399AbYA3Jb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 04:31:29 -0500
Received: from mga02.intel.com ([134.134.136.20]:63289 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759378AbYA3Jb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 04:31:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,276,1199692800"; 
   d="scan'208";a="255816997"
Subject: ioremap_xxx() with EXEC enabled
From: "Huang, Ying" <ying.huang@intel.com>
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 30 Jan 2008 17:32:10 +0800
Message-Id: <1201685530.17912.11.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 30 Jan 2008 09:31:11.0631 (UTC) FILETIME=[D9ED61F0:01C86322]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On i386, EFI may need to map EFI runtime code area as EXEC enabled with
ioremap(). But, I found that the memory are mapped as EXEC disabled when
mapped with ioremap() now. I think we may need a method to map memory
area as EXEC enabled with ioremap_xxx(). Some possible interface schemes
for mapping as EXEC enabled are as follow:

- Interface scheme 1:

ioremap_cache_exec()
ioremap_uncache_exec()

- Interface scheme 2:

enum ioremap_mode {
	IOR_MODE_UNCACHED,
	IOR_MODE_CACHED,
};

enum ioremap_xmode {
	IOR_XMODE_UNEXEC,
	IOR_XMODE_EXEC,
};

void __iomem *__ioremap(unsigned long phys_addr, unsigned long size,
			enum ioremap_mode mode,
			enum ioremap_xmode xmode);


Which one do you think is better? Or we should use some other interface
or method?

Best Regards,
Huang Ying

