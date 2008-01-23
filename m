Return-Path: <linux-kernel-owner+w=401wt.eu-S1756109AbYAWH0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbYAWH0R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 02:26:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753464AbYAWH0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 02:26:03 -0500
Received: from mga02.intel.com ([134.134.136.20]:55810 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654AbYAWH0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 02:26:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,237,1199692800"; 
   d="scan'208";a="328657951"
Subject: Re: Could you please merge the x86_64 EFI boot support patchset?
From: "Huang, Ying" <ying.huang@intel.com>
To: Paul Jackson <pj@sgi.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, hpa@zytor.com,
       ak@suse.de, adaplas@pol.net, linux-kernel@vger.kernel.org
In-Reply-To: <20080123010051.969d21fd.pj@sgi.com>
References: <1194831950.17223.44.camel@caritas-dev.intel.com>
	 <20080123010051.969d21fd.pj@sgi.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 23 Jan 2008 15:26:06 +0800
Message-Id: <1201073166.4945.41.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 23 Jan 2008 07:25:30.0038 (UTC) FILETIME=[21E55D60:01C85D91]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-01-23 at 01:00 -0600, Paul Jackson wrote:
> In Nov 2007, Huang Ying wrote:
> > Could you please merge the following patchset:
> > 
> > [PATCH 0/2 -v3] x86_64 EFI boot support
> > [PATCH 1/2 -v3] x86_64 EFI boot support: EFI frame buffer driver
> > [PATCH 2/2 -v3] x86_64 EFI boot support: EFI boot document
> 
> Huang - what has become of this patchset?

This patchset has been merged into Linux 2.6.24.

> We (SGI) have designs on a big honkin NUMA box using x86_64 arch, and
> we are runnning up against the arbitrary limits on the memory map size
> due to the ancient 4k zero page size limit (hence H. Peter Anvin added
> to the CC list, since he knows a bazillion times more about any such
> limits than I do.).  The limits on 128 or so local chunks of memory
> imposed by the kernel code that invokes Int 15 E820h are too small for
> us.
> 
> Since we are already accustomed to dealing with EFI on our IA64
> Itanium boxes, I'm figuring that it will be easier in the short run,
> and better in the long run, to just use EFI on these upcoming big
> x86_64 NUMA boxes.

Unfortunately, the new EFI support patches do not use EFI memory map for
system boot up (just for runtime service support). The EFI memory map is
converted into E820 memory map in bootloader. The main reason for this
change is to remove the duplication between E820 memory map and EFI
memory map handling code.

So, I think the resolution for your problem is the "struct setup_data"
mechanism proposed by H. Peter Anvin. That is a linked list data
structure for boot parameter without size limitation. I have ever writen
a patch for it, but there are some issues for implementation scheme.
Most people think it should be based on the "early reservation/early
allocation" mechanism from Andi Kleen. So I am waiting that is merged by
-mm or git-x86.

Best Regards,
Huang Ying

