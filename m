Return-Path: <linux-kernel-owner+w=401wt.eu-S1753823Ab0ALJAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab0ALJAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 04:00:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753736Ab0ALJAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 04:00:40 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47277 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab0ALJAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 04:00:40 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 12 Jan 2010 17:57:24 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Zheng, Shaohui" <shaohui.zheng@intel.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ak@linux.intel.com" <ak@linux.intel.com>,
       "y-goto@jp.fujitsu.com" <y-goto@jp.fujitsu.com>,
       Dave Hansen <haveblue@us.ibm.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [ RESEND PATCH v3] Memory-Hotplug: Fix the bug on interface
 /dev/mem for 64-bit kernel
Message-Id: <20100112175724.adfa04d6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <DA586906BA1FFC4384FCFD6429ECE860316C01D6@shzsmsx502.ccr.corp.intel.com>
References: <DA586906BA1FFC4384FCFD6429ECE860316C0133@shzsmsx502.ccr.corp.intel.com>
	<20100112170433.394be31b.kamezawa.hiroyu@jp.fujitsu.com>
	<DA586906BA1FFC4384FCFD6429ECE860316C01D6@shzsmsx502.ccr.corp.intel.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jan 2010 16:57:40 +0800
"Zheng, Shaohui" <shaohui.zheng@intel.com> wrote:

> 
> 3 points...
> 1. I think this patch cannot be compiled in archs other than x86. Right ?
>    IOW, please add static inline dummy...
> [Zheng, Shaohui] Agree, I will add a static dummy function
> 
> 2. pgdat->[start,end], totalram_pages etc...are updated at memory hotplug.
>    Please place the hook nearby them.
> [Zheng, Shaohui] Agree.
> 
> 3. I recommend you yo use memory hotplug notifier.
>    If it's allowed, it will be cleaner.
>    It seems there are no strict ordering to update parameters this patch touches.
> 
> [Zheng, Shaohui] Kame, do you means put the hook into function slab_mem_going_online_callback, it seems a good idea. If we select this method, we will need not to update these variable in function add_memory explicitly.
> 
yes. I think callback is the best.

Thanks,
-Kame

