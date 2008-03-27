Return-Path: <linux-kernel-owner+w=401wt.eu-S1759375AbYC0Jdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759375AbYC0Jdj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 05:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757478AbYC0JdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 05:33:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:10660 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758301AbYC0JdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 05:33:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,562,1199692800"; 
   d="scan'208";a="361426688"
Subject: Re: [PATCH -mm 0/4] x86_64 boot: Add linked listof struct
	setup_data to boot protocol
From: "Huang, Ying" <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de, Paul Jackson <pj@sgi.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080327083221.GD15626@elte.hu>
References: <1206601743.3067.20.camel@caritas-dev.intel.com>
	 <20080327083221.GD15626@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 27 Mar 2008 17:25:36 +0800
Message-Id: <1206609936.13404.0.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 27 Mar 2008 09:22:35.0104 (UTC) FILETIME=[17995E00:01C88FEC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-27 at 09:32 +0100, Ingo Molnar wrote:
> * Huang, Ying <ying.huang@intel.com> wrote:
> 
> > This patchset adds the linked list of struct setup_data to boot 
> > protocol. This is needed by EDD information and some SGI machine with 
> > E820 entry number > 128.
> 
> what happens with the SGI machine - does it crash (because we overflow 
> the e820 array) - or does it boot up with less memory available and we 
> get this bootup warning:
> 
>     Ooops! Too many entries in the memory map!

SGI guys want to build machine with NUMA node number > 128, so they need
e820 entry number > 128. In current boot protocol, this can not be
passed by boot loader to kernel. So the boot protocol need to be
extended. 

> ?
> 
> I guess we should we raise E820MAX from 128 to 256 (patch below), but if 
> we do something worse (crash), we should fix that side-effect as well.

Because the size of "zero page" is limited to 4k, the entry number of
E820 table in "zero page" is limited too. We can not raise it to 256,
because 20 * 256 = 5120 > 4096.

> > Now, only the x86_64 is supported. The i386 can be supported after 
> > early reservation mechanism for x86 is available.
> 
> could you try to do that nevertheless? We generally prefer feature 
> patches after sensible unification has been done.

I try to port reserve_early() to i386 before. But it is said that the
reserve_early() should be replaced by e820 based early
reservation/allocation mechanism on i386 and x86_64. So I think I should
wait for it.

Best Regards,
Huang Ying

