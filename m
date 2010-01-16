Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606Ab0APBIt (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 20:08:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758369Ab0APBIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 20:08:49 -0500
Received: from mga02.intel.com ([134.134.136.20]:49469 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758113Ab0APBIs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 20:08:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,285,1262592000"; 
   d="scan'208";a="587591004"
From: "Zheng, Shaohui" <shaohui.zheng@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "y-goto@jp.fujitsu.com" <y-goto@jp.fujitsu.com>,
        Dave Hansen <haveblue@us.ibm.com>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Date: Sat, 16 Jan 2010 09:08:41 +0800
Subject: RE: [PATCH-RESEND v4] memory-hotplug: create /sys/firmware/memmap
 entry for new memory
Thread-Topic: [PATCH-RESEND v4] memory-hotplug: create /sys/firmware/memmap
 entry for new memory
Thread-Index: AcqWM277R2FxHEDuQJCxcXuKExCYjQAE7vyA
Message-ID: <DA586906BA1FFC4384FCFD6429ECE86034FF85EB@shzsmsx502.ccr.corp.intel.com>
References: <DA586906BA1FFC4384FCFD6429ECE86031560F92@shzsmsx502.ccr.corp.intel.com>
 <20100115143812.b70161d2.akpm@linux-foundation.org>
In-Reply-To: <20100115143812.b70161d2.akpm@linux-foundation.org>
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

It is very strange issue since I already test it before sending it out, I will retry it in local.

Thanks & Regards,
Shaohui


-----Original Message-----
From: Andrew Morton [mailto:akpm@linux-foundation.org] 
Sent: Saturday, January 16, 2010 6:38 AM
To: Zheng, Shaohui
Cc: linux-mm@kvack.org; linux-kernel@vger.kernel.org; ak@linux.intel.com; y-goto@jp.fujitsu.com; Dave Hansen; Wu, Fengguang; x86@kernel.org
Subject: Re: [PATCH-RESEND v4] memory-hotplug: create /sys/firmware/memmap entry for new memory

On Mon, 11 Jan 2010 10:00:11 +0800
"Zheng, Shaohui" <shaohui.zheng@intel.com> wrote:

> memory-hotplug: create /sys/firmware/memmap entry for hot-added memory
> 
> Interface firmware_map_add was not called in explict, Remove it and add function
> firmware_map_add_hotplug as hotplug interface of memmap.
> 
> When we hot-add new memory, sysfs does not export memmap entry for it. we add
>  a call in function add_memory to function firmware_map_add_hotplug.
> 
> Add a new function add_sysfs_fw_map_entry to create memmap entry, it can avoid 
> duplicated codes.

The patch causes an early exception in kmem_cache_alloc_notrace() -
probably due to a null cache pointer.

config: http://master.kernel.org/~akpm/config-akpm2.txt
