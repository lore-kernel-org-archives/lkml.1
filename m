Return-Path: <linux-kernel-owner+w=401wt.eu-S1753865Ab0ALJHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab0ALJHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 04:07:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804Ab0ALJHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 04:07:04 -0500
Received: from mga11.intel.com ([192.55.52.93]:44229 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753087Ab0ALJHA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 04:07:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,259,1262592000"; 
   d="scan'208";a="763455571"
From: "Zheng, Shaohui" <shaohui.zheng@intel.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ak@linux.intel.com" <ak@linux.intel.com>,
       "y-goto@jp.fujitsu.com" <y-goto@jp.fujitsu.com>,
       Dave Hansen <haveblue@us.ibm.com>, "x86@kernel.org" <x86@kernel.org>
Date: Tue, 12 Jan 2010 17:05:19 +0800
Subject: RE: [ RESEND PATCH v3] Memory-Hotplug: Fix the bug on interface
 /dev/mem for 64-bit kernel
Thread-Topic: [ RESEND PATCH v3] Memory-Hotplug: Fix the bug on interface
 /dev/mem for 64-bit kernel
Thread-Index: AcqTZbuTmdV7v9ZzQia6d7Cb3MStJgAAHJVA
Message-ID: <DA586906BA1FFC4384FCFD6429ECE860316C01EA@shzsmsx502.ccr.corp.intel.com>
References: <DA586906BA1FFC4384FCFD6429ECE860316C0133@shzsmsx502.ccr.corp.intel.com>
	<20100112170433.394be31b.kamezawa.hiroyu@jp.fujitsu.com>
	<DA586906BA1FFC4384FCFD6429ECE860316C01D6@shzsmsx502.ccr.corp.intel.com>
 <20100112175724.adfa04d6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100112175724.adfa04d6.kamezawa.hiroyu@jp.fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
[Zheng, Shaohui] it is okay for me, I will rewrite my patch and test it in local, thanks Kame :).

Thanks,
-Kame


Thanks & Regards,
Shaohui
